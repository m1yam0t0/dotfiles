#!/usr/bin/env bash

PLUG_DIR="${HOME}/.local/share/nvim/site/autoload/plug.vim"

if [ ! -d "${PLUG_DIR}" ]; then
    curl -fLo "${PLUG_DIR}" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "vim-plug is already installed"
fi

