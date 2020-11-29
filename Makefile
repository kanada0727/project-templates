export ENV?=development

ifeq (${ENV}, production)
	dc := docker-compose -f docker/docker-compose.yml
else
	dc := docker-compose -f docker/docker-compose.yml -f docker/docker-compose.override.yml
endif

dc-exec := $(dc) exec app
python-exec := $(dc-exec) pipenv run

.PHONY: build setup setup-development setup-production up down erase sh password jupyter

build:
	$(dc) build

setup:
	make "setup-$(ENV)"

setup-development:
	$(dc) build
	make up
	$(dc-exec) pipenv install --dev --deploy
	$(dc-exec) sh install_labextensions
	make password

setup-production: build

up:
	$(dc) up -d

down:
	$(dc) down

erase:
	$(dc) down -v

sh:
	$(dc-exec) /bin/bash

password:
	$(python-exec) jupyter notebook password
	make down
	make up

jupyter:
	$(python-exec) jupyter lab --allow-root --ip 0.0.0.0
