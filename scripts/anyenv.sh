#!/usr/bin/env bash

# init
eval "$(anyenv init -)"
anyenv install --force-init

# install plugins
git clone https://github.com/znz/anyenv-git.git $(anyenv root)/plugins/anyenv-git
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

# install pyenv & plugins
anyenv install pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

# re-init
eval "$(anyenv init -)"
eval "$(pyenv virtualenv init -)"

# install python for neovim
pyenv install -s 3.7.4
pyenv virtualenv 3.7.4 neovim
pyenv activate neovim
pip install pynvim
