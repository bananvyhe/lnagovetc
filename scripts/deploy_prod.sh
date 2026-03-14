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

ssh "${REMOTE_HOST}" bash -lc "cd ${REMOTE_DIR} && docker compose -f docker-compose.prod.yml up -d --build"
