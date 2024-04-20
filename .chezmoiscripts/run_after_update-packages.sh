#!/usr/bin/env bash

# load environment variables
# shellcheck disable=SC1091
source "${HOME}/.zshenv"
source "${XDG_CONFIG_HOME}/zsh/.zshenv"

# aqua
echo "Update aqua packages..."
aqua i -a -l

# GitHub CLI
echo "Update gh extensions..."
gh extension upgrade --all

# kubectl plugins
echo "Update kubectl plugins..."
krew install < ${HOME}/.krew/plugins.txt
krew upgrade

# neovim
echo "Update neovim plugins..."
nvim --headless "+Lazy! sync" +qa
