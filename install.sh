#!/bin/bash

# install ansible
case "${OSTYPE}" in
	darwin*)
		# macOS
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew install ansible
		;;
	linux*)
		# Linux
		if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
			sudo apt-get update
			sudo apt-get install -y software-properties-common
			sudo apt-add-repository ppa:ansible/ansible
			sudo apt-get update
			sudo apt-get install -y ansible
		fi
		;;
esac

# git clone dotfiles
git clone https://github.com/m1yam0t0/dotfiles.git ~/.dotfiles

# ansible
ansible-playbook ~/.dotfiles/playbook/playbook.yml

# change shell
chsh -s `which zsh`
