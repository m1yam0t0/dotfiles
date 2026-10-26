#!/bin/sh
set -eu

# The parent chezmoi process cannot inherit PATH changes made by its hook.
# Keep the same command valid after the temporary binaries are removed.
for op in "${HOME}/.nix-profile/bin/op" "${HOME}/.local/bin/op"; do
	if [ -x "${op}" ]; then
		exec "${op}" "$@"
	fi
done
exec op "$@"
