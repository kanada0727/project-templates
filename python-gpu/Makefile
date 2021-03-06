export PROJECT_NAME=[PROJECT_NAME]
export ENV?=development

ifeq (${ENV}, production)
	dc := docker-compose -f docker/docker-compose.yml
else
	dc := docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml
endif

dc-exec := $(dc) exec app
python-exec := $(dc-exec) poetry run

.PHONY: setup setup-development setup-production \
		create-volumes poetry-install-dev install-labextensions update-password \
		build up down stop start erase sh jupyter

setup:
	$(MAKE) "setup-$(ENV)"

setup-production: build

setup-development: build create-volumes up poetry-install-dev install-labextensions

poetry-install-dev:
	$(dc-exec) poetry install

install-labextensions:
	$(dc-exec) sh install_labextensions

create-volumes:
	docker volume create --name jupyter-config
	docker volume create --name venv-${PROJECT_NAME}

remove-volumes:
	docker volume rm venv-${PROJECT_NAME}

build:
	$(dc) build $(ARGS)

up:
	$(dc) up -d

down:
	$(dc) down

stop:
	$(dc) stop

start:
	$(dc) start

erase:
	$(dc) down
	$(MAKE) remove-volumes

sh:
	$(dc-exec) /bin/bash

jupyter:
	$(python-exec) task jupyter

update-password:
	$(python-exec) task jupyter-update-password
