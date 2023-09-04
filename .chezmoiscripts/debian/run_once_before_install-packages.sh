#!/usr/bin/env bash

# NOTE: this is workaround. see below comment in issue.
# https://github.com/actions/runner-images/issues/7192#issuecomment-1446766800
# disable phased updates
echo 'APT::Get::Always-Include-Phased-Updates "false";' | sudo tee /etc/apt/apt.conf.d/99-phased-updates

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
