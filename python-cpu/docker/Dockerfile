ARG PROJECT_NAME=app

#---#
FROM python:3.8-slim-buster as base

# build poetry
FROM base as poetry-builder
RUN apt update && apt install -y curl
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

FROM base as project-core
# setting project path
ARG PROJECT_NAME
ENV PROJECT_PATH /root/${PROJECT_NAME}
RUN mkdir $PROJECT_PATH
WORKDIR $PROJECT_PATH

#---#
FROM project-core as development

# install basic commands
RUN apt update && apt install -y procps git vim curl

# install poetry
COPY --from=poetry-builder /root/.poetry /root/.poetry
COPY --from=poetry-builder /root/.bashrc /root/.bashrc
ENV PATH $PATH:/root/.poetry/bin
RUN poetry config virtualenvs.in-project true

# install nodejs for jupyter
COPY --from=node:15.6-buster-slim /usr/local/bin/node /usr/local/bin/node
COPY --from=node:15.6-buster-slim /usr/local/bin/nodejs /usr/local/bin/nodejs
COPY --from=node:15.6-buster-slim /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

CMD ["/bin/bash"]

#---#
FROM project-core as production
COPY ./ ./
RUN poetry install
CMD ["/bin/bash"]
