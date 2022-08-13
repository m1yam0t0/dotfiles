#!/usr/bin/env zsh

# load environment variables from zshenv
source ${HOME}/.zshenv

ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

if [ ! -d ${ZINIT_HOME} ]; then
    git clone https://github.com/zdharma-continuum/zinit.git ${ZINIT_HOME}
else
    echo "zinit is already installed"
fi
