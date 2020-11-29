export ENV?=development

ifeq (${ENV}, production)
	dc := docker-compose -f docker/docker-compose.yml
else
	dc := docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml
endif

dc-exec := $(dc) exec app
python-exec := $(dc-exec) pipenv run

.PHONY: setup setup-development setup-production build up down stop start erase sh password jupyter

setup:
	make "setup-$(ENV)"

setup-development:
	$(dc) build
	make up
	$(dc-exec) pipenv install --dev --deploy
	$(dc-exec) sh install_labextensions
	make password

setup-production: build

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

password:
	$(python-exec) jupyter notebook password
	make down
	make up

jupyter:
	$(dc) exec -d app pipenv run jupyter lab --allow-root --ip 0.0.0.0
