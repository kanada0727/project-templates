ARG PROJECT_NAME=app

#---#
FROM python:3.8-slim as base

# setting project path
ARG PROJECT_NAME
ENV PROJECT_PATH /root/${PROJECT_NAME}
RUN mkdir $PROJECT_PATH
WORKDIR $PROJECT_PATH

# install pipenv
ENV PIPENV_VENV_IN_PROJECT true
RUN pip install pipenv

#---#
FROM base as development
# install basic commands
RUN apt update && apt install -y procps git
# install nodejs for jupyter lab
RUN apt install -y nodejs npm
CMD ["/bin/bash"]

#---#
FROM base as production
COPY ./ ./
RUN pipenv install --deploy
CMD ["/bin/bash"]
