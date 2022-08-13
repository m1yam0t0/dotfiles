#!/usr/bin/env sh

# updgrade to latest packages
sudo apt update
sudo apt upgrade -y

# install packages
sudo apt install -y \
    curl \
    git \
    locales \
    tig \
    tmux \
    zsh
