# ==============================================================================
#  TravelApp — Docker Makefile
#  Usage: make <target>
# ==============================================================================

# ── Configuration ──────────────────────────────────────────────────────────────
COMPOSE         := docker compose
APP_CONTAINER   := travel-backend
DB_CONTAINER    := travel-db

# Colours for pretty output
GREEN  := \033[0;32m
YELLOW := \033[0;33m
CYAN   := \033[0;36m
RESET  := \033[0m

# Prevent make from treating targets as files
.PHONY: help start stop restart build up down logs shell \
        migrate seed fresh db-shell \
        cache-clear cache-config cache-route \
        test lint ps prune

# ── Default target ─────────────────────────────────────────────────────────────
.DEFAULT_GOAL := help

# ==============================================================================
#  HELP
# ==============================================================================
help: ## Show this help message
	@echo ""
	@echo "  $(CYAN)TravelApp — Available commands$(RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ \
		{ printf "  $(GREEN)%-18s$(RESET) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

# ==============================================================================
#  CORE — Start / Stop / Restart
# ==============================================================================
start: ## Start containers (build if missing, up if already built)
	@echo "$(YELLOW)▶ Checking containers...$(RESET)"
	@if [ -z "$$($(COMPOSE) ps -q 2>/dev/null)" ]; then \
		echo "$(YELLOW)▶ No containers found — building and starting...$(RESET)"; \
		$(COMPOSE) up --build -d; \
	else \
		echo "$(YELLOW)▶ Containers found — starting...$(RESET)"; \
		$(COMPOSE) start; \
	fi
	@echo "$(GREEN)✔ Application is up → http://localhost:8080$(RESET)"

stop: ## Stop running containers (preserves data)
	@echo "$(YELLOW)▶ Stopping containers...$(RESET)"
	@$(COMPOSE) stop
	@echo "$(GREEN)✔ Containers stopped$(RESET)"

restart: ## Restart all containers
	@echo "$(YELLOW)▶ Restarting containers...$(RESET)"
	@$(COMPOSE) restart
	@echo "$(GREEN)✔ Containers restarted$(RESET)"

build: ## Force rebuild all images then start
	@echo "$(YELLOW)▶ Rebuilding images...$(RESET)"
	@$(COMPOSE) up --build -d
	@echo "$(GREEN)✔ Build complete → http://localhost:8080$(RESET)"

up: ## Start containers in foreground (shows live logs)
	@$(COMPOSE) up

down: ## Stop and remove containers (data volumes preserved)
	@echo "$(YELLOW)▶ Bringing down containers...$(RESET)"
	@$(COMPOSE) down
	@echo "$(GREEN)✔ Done$(RESET)"

# ==============================================================================
#  LOGS & MONITORING
# ==============================================================================
logs: ## Tail logs from all containers
	@$(COMPOSE) logs -f

logs-app: ## Tail logs from the app container only
	@$(COMPOSE) logs -f $(APP_CONTAINER)

ps: ## Show container status
	@$(COMPOSE) ps

# ==============================================================================
#  SHELL ACCESS
# ==============================================================================
shell: ## Open a bash shell inside the app container
	@$(COMPOSE) exec $(APP_CONTAINER) bash

db-shell: ## Open MySQL shell inside the db container
	@$(COMPOSE) exec $(DB_CONTAINER) mysql -u travel_user -psecret travel

# ==============================================================================
#  LARAVEL — Artisan shortcuts
# ==============================================================================
migrate: ## Run database migrations
	@echo "$(YELLOW)▶ Running migrations...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan migrate --force
	@echo "$(GREEN)✔ Migrations done$(RESET)"

seed: ## Run database seeders
	@echo "$(YELLOW)▶ Seeding database...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan db:seed --force
	@echo "$(GREEN)✔ Seeding done$(RESET)"

fresh: ## Drop all tables, re-migrate and re-seed (⚠ destroys data)
	@echo "$(YELLOW)⚠ Resetting database — all data will be lost...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan migrate:fresh --seed --force
	@echo "$(GREEN)✔ Database reset complete$(RESET)"

# ── Cache ──────────────────────────────────────────────────────────────────────
cache-clear: ## Clear all Laravel caches
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan cache:clear
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan config:clear
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan route:clear
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan view:clear
	@echo "$(GREEN)✔ Caches cleared$(RESET)"

cache-build: ## Rebuild Laravel config/route cache (for production)
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan config:cache
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan route:cache
	@echo "$(GREEN)✔ Cache rebuilt$(RESET)"

# ── Keys & JWT ─────────────────────────────────────────────────────────────────
key: ## Generate Laravel APP_KEY
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan key:generate

jwt-secret: ## Generate JWT secret
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan jwt:secret

# ==============================================================================
#  TESTING & QUALITY
# ==============================================================================
test: ## Run PHPUnit test suite
	@echo "$(YELLOW)▶ Running tests...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) php artisan test
	@echo "$(GREEN)✔ Tests complete$(RESET)"

lint: ## Run PHP syntax check on custom source
	@echo "$(YELLOW)▶ Checking PHP syntax...$(RESET)"
	@$(COMPOSE) exec $(APP_CONTAINER) find /var/www/html/app -name "*.php" \
		-exec php -l {} \; | grep -v "No syntax errors"
	@echo "$(GREEN)✔ Lint complete$(RESET)"

# ==============================================================================
#  CLEANUP
# ==============================================================================
prune: ## ⚠ Remove containers, images AND volumes (full reset)
	@echo "$(YELLOW)⚠ This will delete ALL containers, images and volumes...$(RESET)"
	@read -p "Are you sure? [y/N] " confirm && [ "$$confirm" = "y" ]
	@$(COMPOSE) down -v --rmi all --remove-orphans
	@echo "$(GREEN)✔ Full cleanup done$(RESET)"
