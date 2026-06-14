#!/usr/bin/env bash
set -euo pipefail

flake_dir="${HOME}/.config/home-manager"
bootstrap_profile="${HOME}/.local/state/nix/profiles/home-manager-bootstrap"

if [ ! -e "${flake_dir}/flake.nix" ]; then
	echo "${flake_dir}/flake.nix does not exist. Skip Home Manager activation."
	exit 0
fi

load_nix_profile() {
	if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
		# shellcheck disable=SC1091
		. "${HOME}/.nix-profile/etc/profile.d/nix.sh"
	elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
		# shellcheck disable=SC1091
		. "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
	fi
}

load_nix_profile

mkdir -p "${HOME}/.cache/nix"

if ! command -v nix >/dev/null 2>&1; then
	if command -v curl >/dev/null 2>&1; then
		curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes --no-confirm
	elif command -v wget >/dev/null 2>&1; then
		wget -qO- https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes --no-confirm
	else
		echo "curl or wget is required to install Nix." >&2
		exit 1
	fi

	load_nix_profile
fi

mkdir -p "$(dirname "${bootstrap_profile}")"

if [ -x "${bootstrap_profile}/bin/home-manager" ]; then
	:
else
	nix profile install --profile "${bootstrap_profile}" "${flake_dir}#home-manager"
fi

"${bootstrap_profile}/bin/home-manager" switch --flake "${flake_dir}#m1yam0t0"
