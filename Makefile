include .env
export
export ENV?=development

ifeq (${ENV}, production)
	dc := docker-compose -f docker/docker-compose.yml
else
	dc := docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml
endif

dc-exec := $(dc) exec app
python-exec := $(dc-exec) pipenv run

.PHONY: setup setup-development setup-production \
		create-volumes pipenv-deploy install-labextensions password \
		build up down stop start erase sh jupyter

setup:
	make "setup-$(ENV)"

setup-production: build

setup-development: build create-volumes up pipenv-deploy install-labextensions

create-volumes:
	docker volume create --name jupyter-config
	docker volume create --name venv-${PROJECT_NAME}

pipenv-deploy:
	$(dc-exec) pipenv install --dev --deploy

install-labextensions:
	$(dc-exec) sh install_labextensions

password:
	$(python-exec) jupyter notebook password

build:
	$(dc) build

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
	$(dc) exec -d app pipenv run jupyter lab --allow-root --ip 0.0.0.0
