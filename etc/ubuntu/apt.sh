#!/usr/bin/env sh

# updgrade to latest packages
sudo apt update
sudo apt upgrade

# install packages
sudo apt install -y \
    curl \
    git \
    language-pack-ja \
    neovim \
    python \
    silversearcher-ag \
    tig \
    tmux \
    zsh

# change LANG
sudo update-locale LANG=ja_JP.UTF-8

