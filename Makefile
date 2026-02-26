SHELL := /bin/bash

.PHONY: bootstrap up up-full down logs shell test hello doctor \
	bootstrap-native up-native up-native-full down-native test-native

bootstrap:
	./scripts/bootstrap.sh

bootstrap-native:
	./scripts/native_bootstrap.sh

up:
	docker compose --profile core up -d postgres redis web

up-full:
	docker compose --profile core --profile full up -d

down:
	docker compose down

up-native:
	./scripts/native_up.sh

up-native-full:
	./scripts/native_up_full.sh

down-native:
	./scripts/native_down.sh

logs:
	docker compose logs -f --tail=200

shell:
	docker compose exec web bash

test:
	docker compose --profile core run --rm web bash -lc "cd /app/backend && bundle exec rails test"
	@if [ -f frontend/package.json ]; then docker compose --profile full run --rm vite bash -lc "cd /app/frontend && npm run build"; fi

test-native:
	cd backend && bundle exec rails test
	@if [ -f frontend/package.json ]; then cd frontend && npm run build; fi

hello:
	@curl -fsS http://localhost:3000 >/dev/null && echo "OK: http://localhost:3000"

doctor:
	@command -v docker >/dev/null || (echo "docker not found" && exit 1)
	@docker compose version >/dev/null || (echo "docker compose plugin not found" && exit 1)
	@echo "OK: docker + compose available"
