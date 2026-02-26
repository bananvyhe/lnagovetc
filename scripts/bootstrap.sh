#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker not found"
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "ERROR: docker compose plugin not found"
  exit 1
fi

if [[ ! -f .env ]]; then
  cp .env.example .env
fi

mkdir -p backend frontend

docker compose --profile core pull postgres redis || true
docker compose build web

./scripts/init_rails.sh
./scripts/init_vue.sh

docker compose --profile core up -d postgres redis

docker compose --profile core run --rm web bash -lc "cd /app/backend && bundle install && bundle exec rails db:prepare"

echo "Bootstrap complete"
echo "Run: make up"
echo "Run: make up-full"
