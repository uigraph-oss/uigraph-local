COMPOSE := docker compose -f docker-compose.yml

UI_DIR      := ../uigraph-ui
API_DIR     := ../uigraph-api
GRAPHQL_DIR := ../uigraph-graphql
GATEWAY_DIR := ../uigraph-gateway

-include .env
export

.PHONY: up dev down

up:
	$(COMPOSE) up -d --wait

down:
	$(COMPOSE) down

dev:
	set -a && . ./.env && set +a && \
	concurrently --names "API,GRAPHQL,GATEWAY,UI" \
		--prefix-colors "blue,magenta,green,yellow" \
		--kill-others \
		"cd $(API_DIR) && air" \
		"cd $(GRAPHQL_DIR) && PORT=8090 air" \
		"cd $(GATEWAY_DIR) && PORT=8081 tsx watch src/index.ts" \
		"cd $(UI_DIR) && PORT=3000 pnpm dev"
