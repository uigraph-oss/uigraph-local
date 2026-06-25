COMPOSE := docker compose -f docker-compose.yml

UI_DIR      := ../uigraph-ui
API_DIR     := ../uigraph-api
GRAPHQL_DIR := ../uigraph-graphql
GATEWAY_DIR := ../uigraph-gateway

.PHONY: up dev down

up:
	$(COMPOSE) up -d --wait

down:
	$(COMPOSE) down

dev:
	concurrently --names "UI,API,GRAPHQL,GATEWAY" \
		--prefix-colors "blue,magenta,green,yellow" \
		--kill-others-on-fail \
		"cd $(UI_DIR) && PORT=$$UI_PORT pnpm dev"\
		"cd $(API_DIR) && PORT=$$API_PORT air" \
		"cd $(GRAPHQL_DIR) && PORT=$$GRAPHQL_PORT air" \
		"cd $(GATEWAY_DIR) && PORT=$$GATEWAY_PORT tsx --watch src/index.ts" \
