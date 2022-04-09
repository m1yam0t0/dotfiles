#!/usr/bin/env sh

# updgrade to latest packages
sudo apt update
sudo apt upgrade

# install packages
sudo apt install -y \
    curl \
    git \
    locales \
    python \
    tig \
    tmux \
    zsh

# change LANG
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8

