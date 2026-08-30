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
        git -C $(CEP_DIR) git-pull

#==================
# Building images

build-base:
        cd $(CEP_SERVER_DIR) && make build-base

build-community:
        cd $(CEP_SERVER_DIR) && make build-community

build: build-base build-community

up: build
    	$(COMPOSE) up -d

docker-pull:
        $(COMPOSE) pull mongo redis cloudflared

pull: git-pull docker-pull

update: git-pull build docker-pull
        $(COMPOSE) up -d

down:
        $(COMPOSE) down

logs:
        $(COMPOSE) logs -f

all: update