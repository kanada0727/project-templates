export PROJECT_NAME=[PROJECT_NAME]
export ENV?=development
include .env

ifeq (${ENV}, production)
	dc := docker-compose -f docker/docker-compose.yml
else
	dc := docker-compose -f docker/docker-compose.yml -f docker/docker-compose.development.yml
endif

dc-exec := $(dc) exec app

ifeq ($(shell test -f /.dockerenv && echo -n yes),yes)
# inside container
	conda-exec := conda 
else
# outside container
	conda-exec := $(dc-exec) conda 
endif

.PHONY: setup setup-development setup-production create-volumes \
		build up down stop start erase sh \
		conda-deploy conda-export conda-init \
		install-labextensions jupyter-up jupyter-update-password \

setup:
	$(MAKE) "setup-$(ENV)"

setup-development: build create-volumes up conda-deploy

setup-production: build

create-volumes:
	docker volume create --name conda-cache

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

conda-deploy:
	$(conda-exec) env create -f=environment.yml -p /root/[PROJECT_NAME]/.envs

conda-export:
	$(conda-exec) env export > environment.yml

conda-init:
	$(conda-exec) create -p /root/[PROJECT_NAME]/.envs -y

install-labextensions:
	$(dc-exec) sh install_labextensions

jupyter-up:
	jupyter lab --allow-root --ip 0.0.0.0 --port ${JUPYTER_PORT}

jupyter-update-password:
	jupyter server password
