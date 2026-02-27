#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

usage() {
  cat <<'EOF'
Import production database into local development DB.

Usage:
  ./scripts/import_production_db.sh --dump /path/to/dump.sql
  ./scripts/import_production_db.sh --prod-url "postgres://user:pass@host:5432/dbname"

Options:
  --dump PATH       Path to SQL dump (.sql) or custom dump (.dump/.backup/.bin)
  --prod-url URL    PostgreSQL connection URL for production DB (pg_dump source)
  --yes             Do not ask for confirmation
  -h, --help        Show this help

Local target DB is taken from .env:
  POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB
EOF
}

DUMP_PATH=""
PROD_URL=""
ASSUME_YES="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dump)
      DUMP_PATH="${2:-}"
      shift 2
      ;;
    --prod-url)
      PROD_URL="${2:-}"
      shift 2
      ;;
    --yes)
      ASSUME_YES="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -n "$DUMP_PATH" && -n "$PROD_URL" ]]; then
  echo "Use only one source: --dump or --prod-url" >&2
  exit 1
fi

if [[ -z "$DUMP_PATH" && -z "$PROD_URL" ]]; then
  echo "Provide source via --dump or --prod-url" >&2
  exit 1
fi

POSTGRES_HOST="${POSTGRES_HOST:-localhost}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-lnagovetc_development}"

if [[ "$ASSUME_YES" != "true" ]]; then
  echo "This will RECREATE local DB: ${POSTGRES_DB}"
  read -r -p "Continue? [y/N] " yn
  if [[ "${yn:-}" != "y" && "${yn:-}" != "Y" ]]; then
    echo "Cancelled."
    exit 0
  fi
fi

for cmd in psql pg_restore dropdb createdb; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
done

TEMP_DUMP=""
cleanup() {
  if [[ -n "$TEMP_DUMP" && -f "$TEMP_DUMP" ]]; then
    rm -f "$TEMP_DUMP"
  fi
}
trap cleanup EXIT

if [[ -n "$PROD_URL" ]]; then
  if ! command -v pg_dump >/dev/null 2>&1; then
    echo "Missing required command: pg_dump" >&2
    exit 1
  fi
  TEMP_DUMP="$(mktemp /tmp/lnagovetc_prod_dump.XXXXXX.dump)"
  echo "Dumping production DB..."
  pg_dump --format=custom --no-owner --no-privileges --dbname "$PROD_URL" --file "$TEMP_DUMP"
  DUMP_PATH="$TEMP_DUMP"
fi

if [[ ! -f "$DUMP_PATH" ]]; then
  echo "Dump file not found: $DUMP_PATH" >&2
  exit 1
fi

export PGPASSWORD="$POSTGRES_PASSWORD"

echo "Recreating local DB: $POSTGRES_DB"
psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres \
  -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$POSTGRES_DB' AND pid <> pg_backend_pid();" \
  >/dev/null 2>&1 || true
dropdb --if-exists -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$POSTGRES_DB"
createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$POSTGRES_DB"

case "$DUMP_PATH" in
  *.dump|*.backup|*.bin)
    echo "Restoring custom dump..."
    pg_restore --clean --if-exists --no-owner --no-privileges \
      -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" "$DUMP_PATH"
    ;;
  *)
    echo "Restoring SQL dump..."
    psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$DUMP_PATH"
    ;;
esac

echo "Done. Local DB '$POSTGRES_DB' is imported."
