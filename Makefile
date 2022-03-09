# Executables (local)
DOCKER_COMP = docker-compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php
PHP_RUN = $(DOCKER_COMP) run php

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP_CONT) bin/console
DOT      = $(PHP_RUN) dot

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start down logs sh composer vendor sf cc

## —— 🎵 🐳 The Symfony-docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————

build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub
	@$(DOCKER_COMP) up

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

## —— Composer 🧙 ——————————————————————————————————————————————————————————————

composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————

sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	$(SYMFONY) $(c)

cc: c=c:c ## Clear the cache
cc: sf

## —— Workflow ✔️ ———————————————————————————————————————————————————————————————

dump_workflow: ## Generate a visual representation of the workflow as SVG image (example: make dump_workflow name=blog_publishing)
	@$(eval name ?=)
	$(SYMFONY) workflow:dump $(name) | $(DOT) -Tsvg -o dump/dump_$(name).svg

dump_workflow_mermaid: ## Generate the mermaid code of the workflow (example: make dump_workflow_mermaid name=blog_publishing)
	@$(eval name ?=)
	$(SYMFONY) workflow:dump $(name) --dump-format=mermaid
	@echo "Go on https://mermaid.live/ or on https://stackedit.io/app"

dump_blog_publishing: ## Generate a visual representation of the blog_publishing workflow as SVG image
	$(MAKE) dump_workflow name=blog_publishing

dump_blog_publishing_mermaid:## Generate the mermaid code of the blog_publishing workflow
	$(MAKE) dump_workflow_mermaid name=blog_publishing

dot: ## Dot command
	@$(eval c ?=)
	$(DOT) $(c)

## —— Troubleshooting 😵‍️ ———————————————————————————————————————————————————————

# See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md
permissions: ## Run it if you work on linux and cannot edit some of the project files
	docker-compose run --rm php chown -R $$(id -u):$$(id -g) .

