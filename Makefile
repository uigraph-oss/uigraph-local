COMPOSE := docker compose -f docker-compose.yml

API_DIR     := ../uigraph-api
GRAPHQL_DIR := ../uigraph-graphql
GATEWAY_DIR := ../uigraph-gateway
UI_DIR      := ../uigraph-ui

# Load local env defaults so every subprocess sees the same configuration.
-include .env
export

.PHONY: dev infra-up infra-down down dev-down ps logs

# Start Docker infrastructure, then run all local apps in parallel with hot reload.
dev: infra-up
	concurrently --names "API,GRAPHQL,GATEWAY,UI" \
		--prefix-colors "blue,magenta,green,yellow" \
		--kill-others-on-fail \
		"cd $(API_DIR) && air" \
		"cd $(GRAPHQL_DIR) && air" \
		"pnpm --dir $(GATEWAY_DIR) dev" \
		"pnpm --dir $(UI_DIR) dev"

# Start only the Docker-hosted backing services (postgres, redis, minio).
infra-up:
	$(COMPOSE) up -d --wait

# Stop Docker-hosted backing services.
infra-down:
	$(COMPOSE) down

# Alias for infra-down.
down: infra-down

# Stop everything including all running dev processes started by this Makefile.
dev-down:
	$(COMPOSE) down
	-pkill -f 'air' || true
	-pkill -f 'pnpm.*dev' || true

# Show running containers.
ps:
	$(COMPOSE) ps

# Tail infrastructure logs.
logs:
	$(COMPOSE) logs -f
