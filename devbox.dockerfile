FROM ubuntu:20.04
LABEL maintainer=chithanhnguyen.math@gmail.com

# This docker file build a docker image based on ubuntu 20.04
#    - install some usefull tools for developments
#    - setup non root user 'duser'
#
# To build the image
#     docker build -t ctn:dev -f /path/to/this/dir/devbox.dockerfile /path/to/this/dir
#
# To run the container mounting readonly local .ssh directory to use local ssh keys :
#     docker container run --name devbox --mount type=bind,source="/path/to/home/dir/.ssh",target=/home/duser/.ssh,readonly -it ctn:dev
#
# To run the container mounting also development directory to develop inside :
#     docker volume create development_something
#     docker container run --name dev_something                                               \
#        --mount type=bind,source="/path/to/home/dir/.ssh",target=/home/duser/.ssh,readonly   \
#        --mount type=volume,source=development_something,target=/home/duser/development      \
#        -it ctn:dev
# That will mount the created development_something into the container in 'volume' mode, keep everything inside persistent
# The mounted volume is owned by root. Once inside the container, need to do allow give ownership to user 'duser' :
#     chown -R duser:duser /home/duser/development
#
# Start/stop the container
#     docker container start devbox -i
#     docker container stop devbox -i
#
# To remove everything
#    docker stop $(docker ps -a -q) ; docker container rm $(docker ps -a -q) ;  docker image rm $(docker image ls -a -q) ; docker volume prune -f ; docker network prune -f ; docker system prune -af ;
#
# To view listening ports
#    sudo netstat -tunlp
#

## System setup ######################################################

# Install Ubuntu's packages and utilities #########################
RUN apt-get update ; apt-get install -y apt-utils curl ;                      \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sudo openssh-client wget lsof net-tools                                   \
    vim git build-essential python3 python3-pip python3-dev yarn;             \
    wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz ; \
    tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz ;     \
    rm go1.15.6.linux-amd64.tar.gz ;                         \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 100 ;\
    update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100 ;

# TODO build/install latest cmake

# Install python's packages
RUN python3 -m pip install --upgrade pip ; \
    python3 -m pip install                 \
    pytest requests                        \
    numpy scipy matplotlib graphviz        \
    py-solc web3 protobuf jsonschema       \
    mkdocs pymdown-extensions plantuml_markdown ;

# Setup sudoer user 'duser:duser'
RUN useradd -m duser -d /home/duser -p $(openssl passwd duser); usermod -aG sudo duser ;

## User setup #######################################################
USER duser
WORKDIR /home/duser

# Install node through nvm. It's recommended to install as specific user
ARG NVM_VERSION=0.35.3
ARG NODE_VERSION=14.16.0
ENV NODE_PATH /home/duser/.nvm/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $PATH:/home/duser/.nvm/versions/node/v$NODE_VERSION/bin
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash; \
    /bin/bash -c "source /home/duser/.nvm/nvm.sh ; nvm install v$NODE_VERSION" ;     \
    npm install -g --unsafe-perm=true --allow-root truffle@5.2.0 ;                   \
    npm install -g solc@0.8.1 ganache-cli mocha cheerio;


RUN mkdir -p /home/duser/.ssh ; \
    echo "export GOROOT=/usr/local/go/" >> /home/duser/.bashrc ;                                   \
    echo "export PATH=$PATH:$GOROOT/bin:$($GOROOT/bin/go env GOPATH)/bin" >> /home/duser/.bashrc ; \
    echo "export PS1=\"\\u@docker:\\\$PWD \\\$>\"" >> /home/duser/.bashrc;

# Use my vim configuration
RUN git clone https://github.com/ctnguyen/.vim.git ; rm -fR .vim/.git .vim/.gitignore ; \
    git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree ; vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q ;   \
    git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline ; vim -u NONE -c "helptags ~/.vim/pack/plugins/start/lightline/doc" -c q ;\
    git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go ; vim -u NONE -c "helptags ~/.vim/pack/plugins/start/vim-go/doc" -c q ;           \
    git clone https://github.com/puremourning/vimspector ~/.vim/pack/vimspector/opt/vimspector ;          \
    python3 ~/.vim/pack/vimspector/opt/vimspector/install_gadget.py --enable-python --force-enable-node ; \
    git clone --depth=1 https://github.com/bfrg/vim-cpp-modern ~/.vim/pack/git-plugins/start ; \
    rm ~/.vim/pack/git-plugins/start/README.md ; rm -fR ~/.vim/pack/git-plugins/start/.git ;   \
    git clone https://github.com/pangloss/vim-javascript.git ~/.vim/pack/vim-javascript/start/vim-javascript ; \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ; \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf ; ~/.fzf/install ; \
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim ;  \
    vim  -c "PlugInstall" -c q -c q ;

# keep the container on
#CMD ["tail", "-f", "/dev/null"]



## Setup vim in one line
# cd $HOME; git clone https://github.com/ctnguyen/.vim.git ; rm -fR .vim/.git .vim/.gitignore ; git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree ; vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q ; git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline ; vim -u NONE -c "helptags ~/.vim/pack/plugins/start/lightline/doc" -c q ; git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go ; vim -u NONE -c "helptags ~/.vim/pack/plugins/start/vim-go/doc" -c q ; git clone https://github.com/puremourning/vimspector ~/.vim/pack/vimspector/opt/vimspector ; python3 ~/.vim/pack/vimspector/opt/vimspector/install_gadget.py --enable-python --force-enable-node ; git clone --depth=1 https://github.com/bfrg/vim-cpp-modern ~/.vim/pack/git-plugins/start ; rm ~/.vim/pack/git-plugins/start/README.md ; rm -fR ~/.vim/pack/git-plugins/start/.git ; git clone https://github.com/pangloss/vim-javascript.git ~/.vim/pack/vim-javascript/start/vim-javascript ; curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ; git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf ; ~/.fzf/install ; git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim ; vim  -c "PlugInstall" -c q -c q ;
