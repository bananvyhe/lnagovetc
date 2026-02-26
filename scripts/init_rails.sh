#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f backend/Gemfile ]]; then
  echo "Rails app already exists: backend/"
  exit 0
fi

docker compose --profile core run --rm web bash -lc "cd /app && rails _8.0.2_ new backend --database=postgresql --skip-javascript --skip-hotwire --skip-action-mailbox --skip-action-text --skip-system-test"

docker compose --profile core run --rm web bash -lc "cd /app/backend && bundle add sidekiq redis"

cat > backend/config/database.yml <<'YAML'
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("POSTGRES_HOST", "postgres") %>
  port: <%= ENV.fetch("POSTGRES_PORT", "5432") %>
  username: <%= ENV.fetch("POSTGRES_USER", "postgres") %>
  password: <%= ENV.fetch("POSTGRES_PASSWORD", "postgres") %>

development:
  <<: *default
  database: <%= ENV.fetch("POSTGRES_DB", "lnagovetc_development") %>

test:
  <<: *default
  database: <%= ENV.fetch("POSTGRES_DB_TEST", "lnagovetc_test") %>
YAML

if ! grep -q "config.active_job.queue_adapter" backend/config/environments/development.rb; then
  awk '
    /Rails.application.configure do/ { inblock=1 }
    {
      if (inblock && !added && $0 == "end") {
        print "  config.active_job.queue_adapter = :sidekiq"
        added=1
      }
      print
    }
  ' backend/config/environments/development.rb > backend/config/environments/development.rb.tmp
  mv backend/config/environments/development.rb.tmp backend/config/environments/development.rb
fi

cat > backend/config/initializers/sidekiq.rb <<'RUBY'
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/1") }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/1") }
end
RUBY

mkdir -p backend/app/controllers backend/app/views/home backend/app/jobs

cat > backend/app/controllers/home_controller.rb <<'RUBY'
class HomeController < ApplicationController
  def index; end

  def enqueue_hello
    HelloJob.perform_later
    render json: { status: "queued" }
  end
end
RUBY

cat > backend/app/jobs/hello_job.rb <<'RUBY'
class HelloJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info("HelloJob performed")
  end
end
RUBY

cat > backend/app/views/home/index.html.erb <<'ERB'
<h1>Rails is running</h1>
<p>Vue app mount point:</p>
<div id="vue-app"></div>
<script type="module" src="http://localhost:5173/src/main.js"></script>
ERB

cat > backend/config/routes.rb <<'RUBY'
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  post "/hello_job", to: "home#enqueue_hello"
end
RUBY

echo "Rails app initialized"
