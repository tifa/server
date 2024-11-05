.DEFAULT_GOAL := help

ACTIVATE = . venv/bin/activate &&
ANSIBLE = $(ACTIVATE) ansible-playbook -i ./ansible/inventory.yaml
COMPOSE = docker compose

include .env
export

define usage
	@printf "\nUsage: make <command>\n"
	@grep -F -h "##" $(MAKEFILE_LIST) | grep -F -v grep -F | sed -e 's/\\$$//' | awk 'BEGIN {FS = ":*[[:alnum:] _]*##[[:space:]]*"}; \
	{ \
		if($$2 == "") \
			pass; \
		else if($$0 ~ /^#/) \
			printf "\n%s\n", $$2; \
		else if($$1 == "") \
			printf "     %-20s%s\n", "", $$2; \
		else \
			printf "\n    \033[1;33m%-20s\033[0m %s\n", $$1, $$2; \
	}'
endef

.git/hooks/pre-commit: .pre-commit-config.yaml
	$(ACTIVATE) pre-commit install --hook-type pre-commit
	@touch $@

venv: venv/.touchfile .git/hooks/pre-commit
venv/.touchfile: requirements.txt
	@test -d venv || python3 -m venv venv
	@$(ACTIVATE) pip install -U uv && uv pip install -Ur requirements.txt
	@touch $@

.PHONY: help
help: ## Show this message
	$(usage)

.PHONY: check
check: venv  ## Run pre-commit checks
	@$(ACTIVATE) pre-commit run --all-files

.PHONY: up
up:  ## Start the local server
	@$(COMPOSE) up --detach --build

.PHONY: down
down:  ## Stop the local server
	@$(COMPOSE) down --remove-orphans --volumes

.PHONY: restart
restart: down up  ## Restart the local server

.PHONY: sh
sh:  ## Open a shell in the local server container
	@$(COMPOSE) exec server bash

.PHONY: bootstrap
bootstrap: venv  ## Bootstrap the server
	@$(ANSIBLE) ./ansible/bootstrap.yaml

.PHONY: provision
provision: venv  ## Provision the server
	@$(ANSIBLE) ./ansible/provision.yaml

.PHONY: git
git: venv  ## Set up automated git deployment for a repo
	@$(ANSIBLE) ./ansible/git.yaml

.PHONY: clean
clean:  ## Clean the environment
	@rm -rf venv
