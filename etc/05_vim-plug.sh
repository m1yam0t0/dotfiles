#!/usr/bin/env sh

PLUG_DIR="${HOME}/.local/share/nvim/site/autoload/plug.vim"

if [ ! -f "${PLUG_DIR}" ]; then
    curl -fLo "${PLUG_DIR}" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "vim-plug is already installed"
fi

if (type nvim > /dev/null 2>&1); then
    echo "install vim plugins"
    nvim +PlugInstall +qall
else
    echo "neovim is not installed"
fi
