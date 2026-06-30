COMPOSE := docker compose -f docker-compose.yml

UI_DIR      := ${UIGRAPH_ROOT}/uigraph-ui
API_DIR     := ${UIGRAPH_ROOT}/uigraph-api
MCP_DIR     := ${UIGRAPH_ROOT}/uigraph-mcp
GRAPHQL_DIR := ${UIGRAPH_ROOT}/uigraph-graphql
GATEWAY_DIR := ${UIGRAPH_ROOT}/uigraph-gateway

.PHONY: up dev down

up:
	$(COMPOSE) up -d --wait

down:
	$(COMPOSE) down

dev:
	concurrently --names "API,GQL,GATEWAY,MCP,FRONTEND" \
		--prefix-colors "blue,magenta,green,cyan,yellow" \
		--kill-others-on-fail \
		"cd $(UI_DIR) && PORT=$$UI_PORT pnpm dev"\
		"cd $(API_DIR) && PORT=$$API_PORT air" \
		"cd $(MCP_DIR) && PORT=$$MCP_PORT air" \
		"cd $(GRAPHQL_DIR) && PORT=$$GRAPHQL_PORT air" \
		"cd $(GATEWAY_DIR) && PORT=$$GATEWAY_PORT pnpm dev" \
