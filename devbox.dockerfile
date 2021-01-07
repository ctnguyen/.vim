FROM ubuntu:20.04
LABEL maintainer=chithanhnguyen.math@gmail.com

# To build the image
#     docker build -t dev:all -f devbox.dockerfile /path/to/this/dir
# To run the container using local ssh key :
#     docker container run --name devbox --mount type=bind,source="/path/to/home/dir/.ssh",target=/home/dev/.ssh,readonly -it dev:all
# Or restart the container
#     docker container start devbox -i

## System setup ######################################################

RUN apt-get update ;                    \
    apt-get install -y                  \
    apt-utils sudo openssh-client wget  \
    vim git build-essential python3 python3-pip ;

RUN python3 -m pip install --upgrade pip ;  \
    python3 -m pip install                  \
    pytest requests  mkdocs                 \
    pymdown-extensions plantuml_markdown    \
    py-solc web3 protobuf jsonschema
# TODO build & install cmake

## Setup sudoer user 'dev:dev'
RUN useradd -m dev -d /home/dev; usermod -aG sudo dev ;                 \
    mkdir -p /home/dev/.ssh ; chown -R dev:dev /home/dev      ;         \
    echo '#' >> home/dev/.bashrc ;                                      \
    echo '#' >> home/dev/.bashrc ;                                      \
    echo 'alias python=/usr/bin/python3' >> home/dev/.bashrc

USER dev
WORKDIR /home/dev
## User setup #######################################################
# Use my vim configuration
RUN git clone https://github.com/ctnguyen/.vim.git ; rm -fR .vim/.git .vim/.gitignore