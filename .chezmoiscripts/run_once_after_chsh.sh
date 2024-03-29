#!/usr/bin/env bash

SHELL_PATH="$(which zsh)"

if [ "$SHELL" != "$SHELL_PATH" ]; then

	# Add SHELL_PATH to /etc/shells
	if grep -q "$SHELL_PATH" /etc/shells; then
		sudo echo "$SHELL_PATH" | sudo tee -a /etc/shells
	fi

	# change default shell
	sudo chsh -s "$SHELL_PATH" "$USER"
else
	echo "${USER}'s shell is already changed."
fi
