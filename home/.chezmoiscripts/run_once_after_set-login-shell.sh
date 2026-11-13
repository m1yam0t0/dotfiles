#!/usr/bin/env bash
set -euo pipefail

# Use zsh installed by the OS package manager as the login shell.
# This runs after macos/apply-nix-darwin.sh, which installs zsh with Homebrew.
case "$(uname -s)" in
Darwin) SHELL_PATH="/opt/homebrew/bin/zsh" ;;
*) SHELL_PATH="/usr/bin/zsh" ;;
esac

if [ ! -x "$SHELL_PATH" ]; then
	echo "${SHELL_PATH} does not exist. Skip changing login shell."
	exit 0
fi

# Add SHELL_PATH to /etc/shells
if ! grep -Fxq "$SHELL_PATH" /etc/shells; then
	echo "$SHELL_PATH" | sudo tee -a /etc/shells
fi

# change default shell
if [ "$SHELL" != "$SHELL_PATH" ]; then
	sudo chsh -s "$SHELL_PATH" "$USER"
else
	echo "${USER}'s shell is already changed."
fi
