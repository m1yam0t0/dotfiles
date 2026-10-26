#!/usr/bin/env bash
set -euo pipefail

bootstrap_profile="${HOME}/.local/state/nix/profiles/onepassword-bootstrap"

if [ -x "${bootstrap_profile}/bin/op" ]; then
	exit 0
fi

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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
