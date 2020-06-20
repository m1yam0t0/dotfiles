#!/usr/bin/env sh

. ${HOME}/.asdf/asdf.sh

PLUG_DIR="${HOME}/.local/share/nvim/site/autoload/plug.vim"
COC_EXTENTIONS_DIR="${HOME}/.config/coc/extensions"

if [ ! -f "${PLUG_DIR}" ]; then
    curl -fLo "${PLUG_DIR}" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "vim-plug is already installed"
fi

if (type nvim > /dev/null 2>&1); then
    echo "install vim plugins"
    nvim +PlugInstall +qall

    echo "install coc plugins"
    mkdir -p ${COC_EXTENTIONS_DIR}
    cd ${COC_EXTENTIONS_DIR}
    if [ ! -f package.json ]; then
        echo '{"dependencies":{}}'> package.json
    fi
    npm install coc-json coc-python --global-style --ignore-scripts --no-bin-links --no-package-lock
    cd -
else
    echo "neovim is not installed"
fi
