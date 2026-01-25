COMMAND_COLOR = \033[36m
DESC_COLOR    = \033[32m
CLEAR_COLOR   = \033[0m
SERVICE_NAME  = minecraft

.PHONY: help
help: ## prints this message ## 
	@echo ""; \
	echo "Usage: make <command>"; \
	echo ""; \
	echo "where <command> is one of the following:"; \
	echo ""; \
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	perl -nle '/(.*?): ## (.*?) ## (.*$$)/; if ($$3 eq "") { printf ( "$(COMMAND_COLOR)%-20s$(DESC_COLOR)%s$(CLEAR_COLOR)\n\n", $$1, $$2) } else { printf ( "$(COMMAND_COLOR)%-20s$(DESC_COLOR)%s$(CLEAR_COLOR)\n%-20s%s\n\n", $$1, $$2, " ", $$3) }';

.PHONY: up
up: ## 🚙 Runs the server ## (docker-compose up -d) 
	@echo "📦 Starting..."
	@docker-compose up -d

.PHONY: stop
stop: ## 🛑 Stops the server ## (docker-compose stop) 
	@echo "🛑 Stopping..."
	@docker-compose stop

.PHONY: down
down: ## 👎 Remove containers and network ## (Keep volumes) 
	@echo "👎🏻 Tearing down..."
	@docker-compose down

.PHONY: build
build: ## �️ Rebuilds the image locally ## (Using Dockerfile) 
	@echo "🛠️ Rebuilding image..."
	@docker-compose build --no-cache
	@$(MAKE) up
	@$(MAKE) logs

.PHONY: restart
restart: ## 🔃 Restarts the container ## (Quick reload)
	@echo "� Restarting..."
	@docker-compose restart
	@$(MAKE) logs

.PHONY: update
update: ## ⬇️ Pulls latest image and restarts ## (For pre-built image users)
	@echo "⬇️ Pulling latest updates..."
	@docker-compose pull
	@$(MAKE) up
	@$(MAKE) logs

.PHONY: logs
logs: ## 🧻 Follow logs ## 
	@docker-compose logs --tail 50 -f $(SERVICE_NAME)

.PHONY: attach
attach: ## � Attach to console ## (Ctrl+P+Q to detach!) 
	@echo "📌 Attaching to console..."
	@echo "⚠️  REMEMBER: Use [Ctrl+P] then [Ctrl+Q] to detach safely."
	@echo "   (Ctrl+C will KILL the server!)"
	@echo ""
	@docker attach fabricserver

.PHONY: clean
clean: ## � Remove everything ## (WARNING: DELETES DATA!)
	@echo "⚠️  WARNING: This will delete the 'minecraft_data' folder!"
	@read -p "Are you sure? [y/N] " ans && [ $${ans:-N} = y ]
	@docker-compose down -v --remove-orphans
	@rm -rf minecraft_data
	@echo "🧹 Cleaned."
