#!/usr/bin/env bash

PLUG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"

if [ ! -f "${PLUG_DIR}" ]; then
    curl -fLo "${PLUG_DIR}" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "vim-plug is already installed."
fi

