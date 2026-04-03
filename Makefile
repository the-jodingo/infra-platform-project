# infra-platform Makefile

.PHONY: help setup run test deploy clean lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Setup the project
	@echo "Setting up infra-platform..."
	@bash scripts/setup.sh

run: ## Run the application locally
	@echo "Running infra-platform..."
	@echo 'Deployment strategy: blue-green'

test: ## Run tests
	@echo "Running tests..."
	@cd tests && python -m pytest -v

deploy: ## Deploy the application
	@echo "Deploying infra-platform..."
	@bash scripts/deploy.sh

clean: ## Clean build artifacts
	@echo "Cleaning..."
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true

lint: ## Run linters
	@echo "Linting..."
	@flake8 app/ --max-line-length=120


