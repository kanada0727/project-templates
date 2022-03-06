
FROM nvidia/cuda:11.6.0-runtime-ubuntu20.04 as base
ENV LC_ALL=C.UTF-8

### setup timezone
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###-----------------------------------------------
### python builder
###-----------------------------------------------
FROM base as python-builder
###### --- add repository for latest minor version of python 3.8 ---
RUN apt update && apt upgrade -y

###### --- install python3.9 and pip ---

RUN apt install -y python3.9 python3.9-dev python3.9-venv python3-pip
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1
RUN pip3 install --upgrade pip

###-----------------------------------------------
### pdm builder
###-----------------------------------------------
FROM python-builder as pdm-builder
RUN apt update && apt install -y curl
RUN curl -sSL https://raw.githubusercontent.com/pdm-project/pdm/main/install-pdm.py | python3 -

###-----------------------------------------------
### project base
###-----------------------------------------------
FROM python-builder as project-base
###### --- install pdm ---
COPY --from=pdm-builder /root/.local /root/.local
COPY --from=pdm-builder /root/.bashrc /root/.bashrc
ENV PATH $PATH:/root/.local/bin
ENV PYTHONPATH /root/.local/share/pdm/venv/lib/python3.9/site-packages/pdm/pep582
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
RUN apt update && apt install -y procps git vim curl tig wget jq tmux

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
