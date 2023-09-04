#!/usr/bin/env bash

# load environment variables
# shellcheck disable=SC1091
source "${HOME}/.zshenv"
source "${XDG_CONFIG_HOME}/zsh/.zshenv"

# aqua
echo "Update aqua packages..."
aqua i -a

# asdf
echo "Update asdf packages..."
asdf update
asdf plugin update --all
asdf install

# neovim
echo "Update neovim plugins..."
nvim --headless "+Lazy! sync" +qa
