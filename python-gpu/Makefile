export PROJECT_NAME=[PROJECT_NAME]
export ENV?=development

ifeq (${ENV}, production)
	dc := docker-compose -f docker/docker-compose.yml
else
	dc := docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml
endif

dc-exec := $(dc) exec app
python-exec := $(dc-exec) pdm run

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: Makefile| sed 's/://')

setup:
	$(MAKE) "setup-$(ENV)"

setup-development: build create-volumes up pdm-install-dev install-labextensions

setup-production: build

create-volumes:
	docker volume create --name local-cache

pdm-install-dev:
	$(dc-exec) pdm sync

install-labextensions:
	$(dc-exec) sh install_labextensions

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

jupyter-up:
	$(python-exec) jupyter-up

jupyter-update-password:
	$(python-exec) jupyter-update-password
