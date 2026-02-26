#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
PATH_PREFIX="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

run() {
  if command -v mise >/dev/null 2>&1; then
    mise exec -- "$@"
  else
    "$@"
  fi
}

mkdir -p tmp/pids log

pg_ctl_bin="$(command -v pg_ctl || true)"
if [[ -z "$pg_ctl_bin" ]] && [[ -x "$HOME/.local/share/mise/installs/postgres/latest/bin/pg_ctl" ]]; then
  pg_ctl_bin="$HOME/.local/share/mise/installs/postgres/latest/bin/pg_ctl"
fi

pg_bindir=""
if command -v pg_config >/dev/null 2>&1; then
  pg_bindir="$(pg_config --bindir)"
  if [[ -n "$pg_bindir" ]]; then
    pg_ctl_bin="${pg_ctl_bin:-$pg_bindir/pg_ctl}"
  fi
fi

postgres_data_dir="${POSTGRES_DATA_DIR:-}"
if [[ -z "$postgres_data_dir" ]]; then
  if [[ -n "$pg_bindir" ]]; then
    pg_root="$(cd "$pg_bindir/.." && pwd)"
    postgres_data_dir="$pg_root/data"
  elif [[ -n "$pg_ctl_bin" ]]; then
    pg_root="$(cd "$(dirname "$pg_ctl_bin")/.." && pwd)"
    postgres_data_dir="$pg_root/data"
  fi
fi

if [[ -n "$pg_ctl_bin" ]] && [[ -n "$postgres_data_dir" ]]; then
  if ! "$pg_ctl_bin" -D "$postgres_data_dir" status >/dev/null 2>&1; then
    "$pg_ctl_bin" -D "$postgres_data_dir" -l "$ROOT_DIR/log/postgres.log" start
    echo "$postgres_data_dir" > "$ROOT_DIR/tmp/pids/postgres.started"
  fi
fi

redis_port="${REDIS_PORT:-6379}"
redis_cli_bin="$(command -v redis-cli || true)"
redis_server_bin="$(command -v redis-server || true)"
if [[ -z "$redis_cli_bin" ]] && [[ -x "$HOME/.local/share/mise/installs/redis/latest/bin/redis-cli" ]]; then
  redis_cli_bin="$HOME/.local/share/mise/installs/redis/latest/bin/redis-cli"
fi
if [[ -z "$redis_server_bin" ]] && [[ -x "$HOME/.local/share/mise/installs/redis/latest/bin/redis-server" ]]; then
  redis_server_bin="$HOME/.local/share/mise/installs/redis/latest/bin/redis-server"
fi

if [[ -n "$redis_cli_bin" ]] && [[ -n "$redis_server_bin" ]]; then
  if ! "$redis_cli_bin" -p "$redis_port" ping >/dev/null 2>&1; then
    mkdir -p "$ROOT_DIR/tmp/redis"
    "$redis_server_bin" --port "$redis_port" --bind 127.0.0.1 --daemonize yes \
      --pidfile "$ROOT_DIR/tmp/pids/redis.pid" --dir "$ROOT_DIR/tmp/redis" \
      --save "" --appendonly no
  fi
fi

if [[ -f tmp/pids/rails.pid ]]; then
  echo "Rails already running (tmp/pids/rails.pid)"
  exit 0
fi

rails_cmd="bundle exec rails server -b 0.0.0.0 -p 3000"
if command -v mise >/dev/null 2>&1; then
  rails_cmd="mise exec -- $rails_cmd"
fi
nohup env PATH="$PATH_PREFIX" bash -c "cd $ROOT_DIR/backend && $rails_cmd" > log/rails.log 2>&1 &

echo $! > tmp/pids/rails.pid

echo "Rails running on http://localhost:3000"
