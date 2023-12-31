#!/usr/bin/env bash

# load environment variables
# shellcheck disable=SC1091
source "${HOME}/.zshenv"
source "${XDG_CONFIG_HOME}/zsh/.zshenv"

# aqua
echo "Update aqua packages..."
aqua i -a -l

# asdf
echo "Update asdf packages..."
asdf update
asdf plugin update --all
asdf install

# GitHub CLI
echo "Update gh extensions..."
gh extension upgrade --all

# neovim
echo "Update neovim plugins..."
nvim --headless "+Lazy! sync" +qa
