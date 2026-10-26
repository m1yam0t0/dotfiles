#!/usr/bin/env bash
set -euo pipefail

# Home Manager runs in another process, so load its packages here as well.
if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
	# shellcheck disable=SC1091
	. "${HOME}/.nix-profile/etc/profile.d/nix.sh"
elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
	# shellcheck disable=SC1091
	. "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi
export PATH="${HOME}/.nix-profile/bin:${PATH}"

# load environment variables
# shellcheck disable=SC1091
source "${HOME}/.zshenv"

# GitHub CLI
if ! gh auth status --hostname github.com --active >/dev/null 2>&1; then
	echo "Sign in to GitHub to continue..."
	gh auth login --hostname github.com --git-protocol https --web
fi
echo "Update gh extensions..."
gh extension upgrade --all

# kubectl plugins
echo "Update kubectl plugins..."
if command -v krew >/dev/null 2>&1; then
	krew install < "${HOME}/.krew/plugins.txt"
	krew upgrade
else
	echo "krew is not installed. Skip kubectl plugin updates."
fi

# neovim
echo "Update neovim plugins..."
nvim --headless "+Lazy! sync" +qa
