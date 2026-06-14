#!/usr/bin/env bash
set -euo pipefail

SHELL_PATH="/usr/bin/zsh"

if [ ! -x "$SHELL_PATH" ]; then
	echo "${SHELL_PATH} does not exist. Skip changing login shell."
	exit 0
fi

if [ "$SHELL" != "$SHELL_PATH" ]; then

	# Add SHELL_PATH to /etc/shells
	if ! grep -Fxq "$SHELL_PATH" /etc/shells; then
		echo "$SHELL_PATH" | sudo tee -a /etc/shells
	fi

	# change default shell
	sudo chsh -s "$SHELL_PATH" "$USER"
else
	echo "${USER}'s shell is already changed."
fi
