export ENV?=development

ifeq (${ENV}, production)
	dc := docker-compose -f docker/docker-compose.yml
else
	dc := docker-compose -f docker/docker-compose.yml -f docker/docker-compose.override.yml
endif

build:
	make "build-$(ENV)"

build-development:
	$(dc) up -d --build
	$(dc) exec jupyter-visualize pipenv install --dev --deploy
	$(dc) exec jupyter-visualize sh install_labextensions

build-production:
	$(dc) build

up:
	$(dc) up -d

down:
	$(dc) down

erase:
	$(dc) down -v

sh:
	$(dc) exec jupyter-visualize /bin/bash

setup-password:
	$(dc) exec jupyter-visualize pipenv run jupyter notebook password

jupyter:
	$(dc) exec -d jupyter-visualize pipenv run jupyter lab --allow-root --ip 0.0.0.0

pipenv-install:
	$(dc) exec jupyter-visualize pipenv install ${package}
