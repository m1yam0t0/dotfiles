#!/bin/bash

# install ansible
case "${OSTYPE}" in
	darwin*)
		# macOS
        xcode-select --install
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		;;
	linux*)
		# Debian
		if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
			sudo apt-get update
			sudo apt-get install -y git
		fi
		;;
esac

# git clone dotfiles
git clone https://github.com/m1yam0t0/dotfiles.git ~/.dotfiles
