CEP_DIR := ./overleaf-cep
CEP_SERVER_DIR := $(CEP_DIR)/server-ce
CEP_REPO := https://github.com/yu-i-i/overleaf-cep.git

ENV_FILE := ../environments/overleaf/.env
COMPOSE := docker compose --env-file $(ENV_FILE)

clone:
	@if [ -d "$(CEP_DIR)/.git" ]; then \
		echo "Repository already exists, skipping clone"; \
	else \
		git clone $(CEP_REPO) $(CEP_DIR); \
	fi

git-pull: clone
	git -C $(CEP_DIR) pull

#==================
# Building images

build-base:
	cd $(CEP_SERVER_DIR) && make build-base

build-community:
	cd $(CEP_SERVER_DIR) && make build-community

build: build-base build-community

build-overleaf-wrapper:
	docker build -f Dockerfile -t sharelatex/sharelatex:ext-ce-docker .

#==================
# updates
update-git: git-pull build

update-docker:
	$(COMPOSE) pull mongo redis cloudflared

#==================
# Base coommands:
up: 
	$(COMPOSE) up -d

pull: git-pull docker-pull

update: update-git build-overleaf-wrapper update-docker up

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

all: update
