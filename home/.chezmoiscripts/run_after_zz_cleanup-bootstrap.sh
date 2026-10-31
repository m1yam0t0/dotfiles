#!/usr/bin/env bash
set -euo pipefail

manifest="${XDG_STATE_HOME:-${HOME}/.local/state}/dotfiles/bootstrap/cleanup"
if [ ! -f "${manifest}" ]; then
	exit 0
fi

# Keep the bootstrap binaries if Home Manager did not install replacements.
for tool in chezmoi gh op; do
	if [ ! -x "${HOME}/.nix-profile/bin/${tool}" ]; then
		echo "Home Manager's ${tool} is missing. Keep bootstrap binaries." >&2
		exit 1
	fi
done

while read -r expected tool; do
	case "${tool}" in
	chezmoi|gh|op) ;;
	*) echo 'Unexpected bootstrap manifest entry.' >&2; exit 1 ;;
	esac
	path="${HOME}/.local/bin/${tool}"
	if [ ! -f "${path}" ]; then
		continue
	fi
	if command -v sha256sum >/dev/null 2>&1; then
		actual="$(sha256sum <"${path}")"
	else
		actual="$(shasum -a 256 <"${path}")"
	fi
	if [ "${actual%% *}" = "${expected}" ]; then
		rm -- "${path}"
	else
		echo "${path} changed after bootstrap. Keep this binary." >&2
	fi
done <"${manifest}"
rm -- "${manifest}"
