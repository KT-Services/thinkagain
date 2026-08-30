STACKS := authentik outline overleaf

NETWORKS := proxy

.PHONY: all up down update pull $(STACKS)

networks:
	@for network in $(NETWORKS); do \
		if ! docker network inspect $$network >/dev/null 2>&1; then \
			echo "---------- Creating network $$network ----------"; \
			docker network create $$network; \
		else \
			echo "---------- Network $$network already exists ----------"; \
		fi; \
	done


all: networks update up

up: networks
	@for stack in $(STACKS); do \
		echo "---------- Starting $$stack... ----------"; \
		$(MAKE) -C $$stack up; \
		echo "---------- Started $$stack ----------"; \
	done

down:
	@for stack in $(STACKS); do \
		echo "---------- Stopping $$stack... ----------"; \
		$(MAKE) -C $$stack down; \
		echo "---------- Stopped $$stack ----------"; \
	done

update:
	@for stack in $(STACKS); do \
		echo "---------- Updating $$stack... ----------"; \
		$(MAKE) -C $$stack update; \
		echo "---------- Updated $$stack ----------"; \
	done

pull:
	@for stack in $(STACKS); do \
		echo "---------- Pulling $$stack... ----------"; \
		$(MAKE) -C $$stack pull; \
		echo "---------- Pulled $$stack ----------"; \
	done

# Run a target on a specific stack:
# make authentik
# make outline
$(STACKS):
	$(MAKE) -C $@ all
