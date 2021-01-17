FROM ubuntu:20.04
LABEL maintainer=chithanhnguyen.math@gmail.com

# To build the image
#     docker build -t ctn:dev -f devbox.dockerfile /path/to/this/dir
#
# To run the container mounting readonly local .ssh directory to use local ssh keys :
#     docker container run --name devbox --mount type=bind,source="/path/to/home/dir/.ssh",target=/home/dev/.ssh,readonly -it ctn:dev
#
# Start/stop the container
#     docker container start devbox -i
#     docker container stop devbox -i
#
# To remove everything
#    docker system prune -a
#
# To view listening ports
#    sudo netstat -tunlp
#

## System setup ######################################################

# Install Ubuntu's packages and utilities
RUN apt-get update ;                                             \
    apt-get install -y                                           \
    apt-utils sudo openssh-client wget curl gnupg lsof net-tools \
    vim git build-essential python3 python3-pip;                 \
    wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz ;     \
    tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz ;         \
    rm go1.15.6.linux-amd64.tar.gz ;                             \
    curl -sL https://deb.nodesource.com/setup_15.x | bash -;     \
    apt-get install -y nodejs; npm install -g npm@7.4.0 ;        \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - ;                             \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list ; \
    apt-get update ; apt-get install -y yarn ;

# TODO build/install latest cmake

# Install python's packages
RUN python3 -m pip install --upgrade pip ; \
    python3 -m pip install  \
    pytest requests         \
    numpy scipy             \
    matplotlib graphviz     \
    py-solc web3 protobuf   \
    jsonschema              \
    mkdocs pymdown-extensions plantuml_markdown

# Install nodejs's packages
RUN npm install -g mocha cheerio truffle web3 ganache-cli


# Setup sudoer user 'dev:dev'
RUN useradd -m dev -d /home/dev -p $(openssl passwd dev); usermod -aG sudo dev ; \
    mkdir -p /home/dev/.ssh ;                                                    \
    mkdir -p /home/dev/src ; mkdir -p /home/dev/build ; mkdir -p /home/dev/bin ; \
    chown -R dev:dev /home/dev ;                                                 \
    echo '#' >> home/dev/.bashrc ;                                               \
    echo '#' >> home/dev/.bashrc ;                                               \
    echo 'alias python=/usr/bin/python3' >> home/dev/.bashrc ;                   \
    echo 'export PATH=$PATH:/usr/local/go/bin' >> home/dev/.bashrc ;

## User setup #######################################################
USER dev
WORKDIR /home/dev
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
