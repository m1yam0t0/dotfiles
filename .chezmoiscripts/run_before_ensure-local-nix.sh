#!/usr/bin/env bash
set -euo pipefail

local_nix="${HOME}/.config/home-manager/packages/local.nix"

if [ -e "${local_nix}" ]; then
	exit 0
fi

mkdir -p "$(dirname "${local_nix}")"

cat >"${local_nix}" <<'EOF'
{ ... }:

{
}
EOF
