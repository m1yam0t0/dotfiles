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

# install 1password-cli
# https://developer.1password.com/docs/cli/get-started#install

# remove files to install 1password-cli
sudo rm -f /usr/share/keyrings/1password-archive-keyring.gpg
sudo rm -rf /etc/debsig/policies/AC2D62742012EA22/
sudo rm -rf /usr/share/debsig/keyrings/AC2D62742012EA22

# add the key for the 1Password apt repository
curl -sS https://downloads.1password.com/linux/keys/1password.asc |
	sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

# add the 1Password apt repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
	sudo tee /etc/apt/sources.list.d/1password.list

# add the debsig-verify policy
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
	sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc |
	sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# install 1password-cli
sudo apt update
sudo apt install -y 1password-cli
