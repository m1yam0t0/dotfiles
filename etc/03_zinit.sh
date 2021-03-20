#!/usr/bin/env zsh

ZINIT_DIR="${HOME}/.zinit"

if [ ! -d ${ZINIT_DIR} ]; then
    mkdir ${ZINIT_DIR}
    git clone https://github.com/zdharma/zinit.git ${ZINIT_DIR}/bin
else
    echo "zinit is already installed"
fi
