dc := docker-compose -f docker/docker-compose.yml

build:
	$(dc) up -d --build
	$(dc) exec jupyter-visualize pipenv install --dev --deploy
	$(dc) exec jupyter-visualize sh install_labextensions

up:
	${dc} up -d

down:
	$(dc) down

sh:
	$(dc) exec jupyter-visualize /bin/bash

setup-password:
	$(dc) exec jupyter-visualize pipenv run jupyter notebook password

pipenv-install:
	$(dc) exec jupyter-visualize pipenv install ${package}
