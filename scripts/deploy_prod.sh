#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REMOTE_HOST="${REMOTE_HOST:-root@81.163.29.109}"
REMOTE_DIR="${REMOTE_DIR:-/srv/lnagovetc}"

rsync -az --delete \
  --exclude node_modules \
  --exclude .git \
  --exclude tmp \
  --exclude log \
  --exclude frontend/dist \
  --exclude .env.production \
  "$ROOT_DIR/" "${REMOTE_HOST}:${REMOTE_DIR}/"

ssh "${REMOTE_HOST}" bash -lc "set -euo pipefail; test -d '${REMOTE_DIR}'; test -f '${REMOTE_DIR}/docker-compose.prod.yml'; test -f '${REMOTE_DIR}/.env.production'; \
  if ! grep -q '^DATABASE_URL=' '${REMOTE_DIR}/.env.production'; then \
    set -a; source '${REMOTE_DIR}/.env.production'; set +a; \
    echo \"DATABASE_URL=postgresql://\${POSTGRES_USER}:\${POSTGRES_PASSWORD}@postgres:5432/\${POSTGRES_DB}\" >> '${REMOTE_DIR}/.env.production'; \
    chmod 600 '${REMOTE_DIR}/.env.production'; \
  fi; \
  cd '${REMOTE_DIR}'; docker compose --env-file '${REMOTE_DIR}/.env.production' -f '${REMOTE_DIR}/docker-compose.prod.yml' up -d --build"
