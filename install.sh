#!/bin/bash

# install ansible
case "${OSTYPE}" in
	darwin*)
		# macOS
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew install ansible
		;;
	linux*)
		# Debian
		if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
			sudo apt-get update
			sudo apt-get install -y software-properties-common
			sudo apt-add-repository ppa:ansible/ansible
			sudo apt-get update
			sudo apt-get install -y ansible git
		fi
		;;
esac

# git clone dotfiles
git clone https://github.com/m1yam0t0/dotfiles.git ~/.dotfiles

# ansible
ansible-playbook -i ~/.dotfiles/playbook/hosts ~/.dotfiles/playbook/playbook.yml

# change shell
sudo chsh -s `which zsh` $USER
