#!/usr/bin/env bash
set -euo pipefail

if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
	# shellcheck disable=SC1091
	. "${HOME}/.nix-profile/etc/profile.d/nix.sh"
elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
	# shellcheck disable=SC1091
	. "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

if command -v nix >/dev/null 2>&1; then
	exit 0
fi

mkdir -p "${HOME}/.cache/nix"

if command -v curl >/dev/null 2>&1; then
	curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes --no-confirm
elif command -v wget >/dev/null 2>&1; then
	wget -qO- https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes --no-confirm
else
	echo "curl or wget is required to install Nix." >&2
	exit 1
fi
