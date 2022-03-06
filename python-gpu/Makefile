export PROJECT_NAME=[PROJECT_NAME]
export ENV?=development

ifeq (${ENV}, production)
	dc := docker-compose -f docker/docker-compose.yml
else
	dc := docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml
endif

dc-exec := $(dc) exec app
python-exec := $(dc-exec) pdm run

.PHONY: setup setup-development setup-production create-volumes \
		poetry-install-dev install-labextensions set-jupyter-password \
		build up down stop start erase sh jupyter

setup:
	$(MAKE) "setup-$(ENV)"

setup-production: build

setup-development: build create-volumes up pdm-install-dev install-labextensions

pdm-install-dev:
	$(dc-exec) pdm install

install-labextensions:
	$(dc-exec) sh install_labextensions

create-volumes:
	docker volume create --name local-cache

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
	$(dc) down -v

sh:
	$(dc-exec) /bin/bash

jupyter:
	$(python-exec) launch-jupyter

jupyter-update-password:
	$(python-exec) jupyter-update-password
