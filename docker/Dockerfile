FROM python:3.8-slim as base
ENV PIPENV_VENV_IN_PROJECT true
ENV PROJECT_PATH /root/app
RUN mkdir $PROJECT_PATH
WORKDIR $PROJECT_PATH
RUN pip install pipenv

FROM base as dev
# jupyter用にnodejs周りのinstall
RUN apt update && apt install -y nodejs npm
# 基本的なコマンドを使えるようにする
RUN apt install -y procps
CMD ["/bin/bash"]

FROM base as prod
COPY ./ ./
RUN pipenv install --deploy
CMD ["/bin/bash"]
