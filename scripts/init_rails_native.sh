#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f backend/Gemfile ]]; then
  echo "Rails app already exists: backend/"
  exit 0
fi

export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

run() {
  if command -v mise >/dev/null 2>&1; then
    mise exec -- "$@"
  else
    "$@"
  fi
}

run rails _8.0.2_ new backend --database=postgresql --skip-javascript --skip-hotwire --skip-action-mailbox --skip-action-text --skip-system-test

cd "$ROOT_DIR/backend"
run bundle add sidekiq redis

cat > "$ROOT_DIR/backend/config/database.yml" <<'YAML'
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("POSTGRES_HOST", "localhost") %>
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

if ! grep -q "config.active_job.queue_adapter" "$ROOT_DIR/backend/config/environments/development.rb"; then
  awk '
    /Rails.application.configure do/ { inblock=1 }
    {
      if (inblock && !added && $0 == "end") {
        print "  config.active_job.queue_adapter = :sidekiq"
        added=1
      }
      print
    }
  ' "$ROOT_DIR/backend/config/environments/development.rb" > "$ROOT_DIR/backend/config/environments/development.rb.tmp"
  mv "$ROOT_DIR/backend/config/environments/development.rb.tmp" "$ROOT_DIR/backend/config/environments/development.rb"
fi

cat > "$ROOT_DIR/backend/config/initializers/sidekiq.rb" <<'RUBY'
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1") }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1") }
end
RUBY

mkdir -p "$ROOT_DIR/backend/app/controllers" "$ROOT_DIR/backend/app/views/home" "$ROOT_DIR/backend/app/jobs"

cat > "$ROOT_DIR/backend/app/controllers/home_controller.rb" <<'RUBY'
class HomeController < ApplicationController
  def index; end

  def enqueue_hello
    HelloJob.perform_later
    render json: { status: "queued" }
  end
end
RUBY

cat > "$ROOT_DIR/backend/app/jobs/hello_job.rb" <<'RUBY'
class HelloJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info("HelloJob performed")
  end
end
RUBY

cat > "$ROOT_DIR/backend/app/views/home/index.html.erb" <<'ERB'
<h1>Rails is running</h1>
<p>Vue app mount point:</p>
<div id="vue-app"></div>
<script type="module" src="http://localhost:5173/src/main.js"></script>
ERB

cat > "$ROOT_DIR/backend/config/routes.rb" <<'RUBY'
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  post "/hello_job", to: "home#enqueue_hello"
end
RUBY

echo "Rails app initialized (native)"
