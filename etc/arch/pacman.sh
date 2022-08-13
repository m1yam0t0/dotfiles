#!/usr/bin/env sh

# upgrade to latest packages
sudo pacman -Syyu --noconfirm

# install packages
sudo pacman -S --noconfirm --needed \
    docker \
    fcitx5-im \
    htop \
    tailscale \
    tig \
    tmux \
    wezterm \
    vivaldi \
    zsh
