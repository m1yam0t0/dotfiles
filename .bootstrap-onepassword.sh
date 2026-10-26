#!/usr/bin/env bash
set -euo pipefail

bootstrap_profile="${HOME}/.local/state/nix/profiles/onepassword-bootstrap"

install_op() {
	if [ -x "${bootstrap_profile}/bin/op" ]; then
		return
	fi

	source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	bash "${source_dir}/.chezmoiscripts/run_before_install-nix.sh"

	# The installer runs in a child shell, so load Nix again in this process.
	if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
		# shellcheck disable=SC1091
		. "${HOME}/.nix-profile/etc/profile.d/nix.sh"
	elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
		# shellcheck disable=SC1091
		. "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
	fi

	mkdir -p "$(dirname "${bootstrap_profile}")"
	nix profile install --profile "${bootstrap_profile}" \
		"path:${source_dir}/dot_config/home-manager#onepassword-cli"
}

install_op

# CI can install the CLI without configuring a personal account.
if [ "${1:-}" = --setup-account ]; then
	op="${bootstrap_profile}/bin/op"
	accounts="$("${op}" account list --format=json)"
	if [[ "${accounts}" =~ ^[[:space:]]*\[[[:space:]]*\][[:space:]]*$ ]]; then
		echo 'Set up your 1Password account to continue. chezmoi will sign in afterward.' >&2
		"${op}" account add
	fi
fi
