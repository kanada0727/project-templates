#---#
FROM python:3.8-slim-buster as base

###-----------------------------------------------
### poetry builder
###-----------------------------------------------
FROM base as poetry-builder
RUN apt update && apt install -y curl
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

###-----------------------------------------------
### project base
###-----------------------------------------------
FROM base as project-base
###### --- install poetry ---
COPY --from=poetry-builder /root/.poetry /root/.poetry
COPY --from=poetry-builder /root/.bashrc /root/.bashrc
ENV PATH $PATH:/root/.poetry/bin
RUN poetry config virtualenvs.in-project true

###-----------------------------------------------
### development
###-----------------------------------------------
FROM project-base as development

###### --- install nodejs for jupyter ---
COPY --from=node:15.6-buster-slim /usr/local/bin/node /usr/local/bin/node
COPY --from=node:15.6-buster-slim /usr/local/bin/nodejs /usr/local/bin/nodejs
COPY --from=node:15.6-buster-slim /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

###### --- install basic commands ---
RUN apt update && apt install -y procps git vim curl tig

###### --- setting project path ---
###### NOTE: put this code in the end to share cache with other projects
ENV PROJECT_PATH /root/[PROJECT_NAME]
WORKDIR $PROJECT_PATH
ENV WORKDIR $PROJECT_PATH
CMD ["/bin/bash"]

###-----------------------------------------------
### production builder
###-----------------------------------------------
FROM project-base as production-builder

###### --- setting project path ---
ENV PROJECT_PATH /root/[PROJECT_NAME]
WORKDIR $PROJECT_PATH

###### --- install python packages ---
COPY ./poetry.lock ./poetry.lock
COPY ./pyproject.toml ./pyproject.toml
RUN poetry install --no-dev

###-----------------------------------------------
### production
###-----------------------------------------------
FROM base as production

###### --- setting project path ---
ENV PROJECT_PATH /root/[PROJECT_NAME]
WORKDIR $PROJECT_PATH

COPY ./ ./

###### --- copy python runtime ---
COPY --from=production-builder $PROJECT_PATH/.venv/ ./.venv
ENV PATH $PATH:$PROJECT_PATH/.venv/bin/python3

CMD ["/bin/bash"]
