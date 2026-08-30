ENV_FILE := ../environments/authentik/.env
COMPOSE := docker compose --env-file $(ENV_FILE)

up:
	$(COMPOSE) up -d

pull:
	$(COMPOSE) pull mongo redis

update: docker-pull

down:
	$(COMPOSE) down

all: update up