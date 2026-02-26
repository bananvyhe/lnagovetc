#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

./scripts/native_up.sh

mkdir -p tmp/pids log

if [[ ! -f tmp/pids/sidekiq.pid ]]; then
  sidekiq_cmd="bundle exec sidekiq"
  if command -v mise >/dev/null 2>&1; then
    sidekiq_cmd="mise exec -- $sidekiq_cmd"
  fi
  nohup env PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH" bash -c "cd $ROOT_DIR/backend && $sidekiq_cmd" > log/sidekiq.log 2>&1 &
  echo $! > tmp/pids/sidekiq.pid
fi

if [[ ! -f tmp/pids/vite.pid ]]; then
  if [[ ! -d "$ROOT_DIR/frontend/node_modules" ]]; then
    if command -v mise >/dev/null 2>&1; then
      (cd "$ROOT_DIR/frontend" && mise exec -- npm install)
    else
      (cd "$ROOT_DIR/frontend" && npm install)
    fi
  fi
  vite_cmd="npm run dev -- --host 0.0.0.0 --port 5173"
  if command -v mise >/dev/null 2>&1; then
    vite_cmd="mise exec -- $vite_cmd"
  fi
  nohup env PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH" bash -c "cd $ROOT_DIR/frontend && $vite_cmd" > log/vite.log 2>&1 &
  echo $! > tmp/pids/vite.pid
fi

echo "Rails: http://localhost:3000"
echo "Vite:  http://localhost:5173"
