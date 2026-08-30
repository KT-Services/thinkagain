ENV_FILE := ../environments/outline/.env
COMPOSE := docker compose #--env-file $(ENV_FILE)

up:
	$(COMPOSE) up -d

docker-pull:
	$(COMPOSE) pull

pull: docker-pull

update: docker-pull

down:
	$(COMPOSE) down

all: update up
