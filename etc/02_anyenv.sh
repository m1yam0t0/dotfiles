#!/usr/bin/env zsh

# install versions
GO_VERSION=1.13.5
NODEJS_VERSION=12.14.0
PYTHON_VERSION=3.7.6

# init
eval "$(anyenv init -)"
anyenv install --force-init

# install envs & plugins
anyenv install -s goenv
anyenv install -s nodenv
anyenv install -s pyenv

# install plugins
eval "$(anyenv init -)"

ANYENV_PLUGIN_DIR="$(anyenv root)/plugins"
if [ ! -d "${ANYENV_PLUGIN_DIR}/anyenv-git" ]; then
    git clone https://github.com/znz/anyenv-git.git ${ANYENV_PLUGIN_DIR}/anyenv-git
fi
if [ ! -d "${ANYENV_PLUGIN_DIR}/anyenv-update" ]; then
    git clone https://github.com/znz/anyenv-update.git ${ANYENV_PLUGIN_DIR}/anyenv-update
fi

PYENV_PLUGIN_DIR="$(pyenv root)/plugins"
if [ ! -d "${PYENV_PLUGIN_DIR}/pyenv-virtualenv" ]; then
    git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_PLUGIN_DIR}/pyenv-virtualenv
fi

# re-init
export GOENV_DISABLE_GOPATH=1
eval "$(anyenv init -)"
eval "$(pyenv virtualenv-init -)"
export GOPATH=~/go
export PATH="$GOPATH/bin:$PATH"

# install go
goenv install -s ${GO_VERSION}
goenv global ${GO_VERSION}
goenv rehash
GO111MODULE=on go get golang.org/x/tools/gopls@latest

# install nodejs
nodenv install -s ${NODEJS_VERSION}
nodenv global ${NODEJS_VERSION}
nodenv rehash
npm install -g yarn neovim bash-language-server dockerfile-language-server-nodejs

# install python
pyenv install -s ${PYTHON_VERSION}
pyenv virtualenv -f ${PYTHON_VERSION} neovim
pyenv rehash
pyenv shell neovim
pip install -U pip
pip install pynvim flake8 black
pyenv shell --unset
