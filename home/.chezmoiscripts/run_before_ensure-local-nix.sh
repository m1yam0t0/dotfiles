#!/usr/bin/env bash
set -euo pipefail

# Create empty machine-local Nix modules if they do not exist yet.
# Edit these files to add packages that are only needed on this machine.
ensure_local_nix() {
	local local_nix="$1"

	if [ -e "${local_nix}" ]; then
		return 0
	fi

	mkdir -p "$(dirname "${local_nix}")"

	cat >"${local_nix}" <<'EOF'
{ ... }:

{
}
EOF
}

# Home Manager: e.g. home.packages = with pkgs; [ ... ];
ensure_local_nix "${HOME}/.config/home-manager/packages/local.nix"

# nix-darwin: e.g. homebrew.casks = [ ... ];
if [ "$(uname -s)" = "Darwin" ]; then
	ensure_local_nix "${HOME}/.config/nix-darwin/local.nix"
fi
