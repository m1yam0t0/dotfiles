#!/usr/bin/env sh

# upgrade to latest packages
sudo pacman -Syyu --noconfirm

# install packages
sudo pacman -S --noconfirm --needed \
    alacritty \
    docker \
    fcitx5-im \
    htop \
    tailscale \
    tig \
    tmux \
    vivaldi \
    zsh
