#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

for name in rails sidekiq vite; do
  pid_file="tmp/pids/${name}.pid"
  if [[ -f "$pid_file" ]]; then
    pid=$(cat "$pid_file" || true)
    if [[ -n "$pid" ]]; then
      kill "$pid" >/dev/null 2>&1 || true
    fi
    rm -f "$pid_file"
  fi
done

if [[ -f tmp/pids/redis.pid ]]; then
  redis_pid=$(cat tmp/pids/redis.pid || true)
  if [[ -n "$redis_pid" ]]; then
    kill "$redis_pid" >/dev/null 2>&1 || true
  fi
  rm -f tmp/pids/redis.pid
fi

if [[ -f tmp/pids/postgres.started ]]; then
  postgres_data_dir="$(cat tmp/pids/postgres.started || true)"
  if [[ -n "$postgres_data_dir" ]]; then
    pg_ctl_bin="$(command -v pg_ctl || true)"
    if [[ -z "$pg_ctl_bin" ]] && [[ -x "$HOME/.local/share/mise/installs/postgres/latest/bin/pg_ctl" ]]; then
      pg_ctl_bin="$HOME/.local/share/mise/installs/postgres/latest/bin/pg_ctl"
    fi
    if [[ -z "$pg_ctl_bin" ]] && command -v pg_config >/dev/null 2>&1; then
      pg_bindir="$(pg_config --bindir)"
      pg_ctl_bin="$pg_bindir/pg_ctl"
    fi
    if [[ -n "$pg_ctl_bin" ]]; then
      "$pg_ctl_bin" -D "$postgres_data_dir" stop -m fast >/dev/null 2>&1 || true
    fi
  fi
  rm -f tmp/pids/postgres.started
fi

echo "Stopped local processes"
