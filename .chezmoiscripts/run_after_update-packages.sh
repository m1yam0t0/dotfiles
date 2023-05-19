#!/usr/bin/env bash

# load environment variables
# shellcheck disable=SC1091
source "${HOME}/.zshenv"
source "${XDG_CONFIG_HOME}/zsh/.zshenv"

# aqua
echo "Update aqua packages..."
aqua i -a

# neovim
echo "Update neovim plugins..."
nvim --headless "+Lazy! sync" +qa
