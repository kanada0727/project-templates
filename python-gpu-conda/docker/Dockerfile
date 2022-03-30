
FROM nvidia/cuda:11.6.0-runtime-ubuntu20.04 as base
ENV LC_ALL=C.UTF-8

### setup timezone
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y wget make
###-----------------------------------------------
### conda builder
###-----------------------------------------------
FROM base as conda-builder
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.11.0-Linux-x86_64.sh -O install-miniconda.sh
RUN bash install-miniconda.sh -b -p /root/.miniconda

###-----------------------------------------------
### project base
###-----------------------------------------------
FROM base as project-base
###### --- install pdm ---
COPY --from=conda-builder /root/.miniconda /root/.miniconda
ENV PATH ${PATH}:/root/.miniconda/bin
RUN conda init bash
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

##### add activate conda setting
RUN echo "conda activate /root/[PROJECT_NAME]/.envs" >> /root/.bashrc
RUN {\
        echo "pkgs_dirs:\n";\
        echo "  - /root/.conda_cache\n";\
    } > /root/.condarc
CMD ["/bin/bash"]
