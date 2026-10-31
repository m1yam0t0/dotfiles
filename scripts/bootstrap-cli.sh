#!/usr/bin/env bash
set -euo pipefail

detect_platform() {
	case "$(uname -s)" in
	Linux) os=linux ;;
	Darwin) os=darwin ;;
	*) echo 'This installer supports Linux and macOS.' >&2; return 1 ;;
	esac
	case "$(uname -m)" in
	x86_64|amd64) arch=amd64 ;;
	aarch64|arm64) arch=arm64 ;;
	*) echo 'This installer supports amd64 and arm64.' >&2; return 1 ;;
	esac
}

verify_sha256() {
	local actual
	if command -v sha256sum >/dev/null 2>&1; then
		actual="$(sha256sum <"$1")"
	else
		actual="$(shasum -a 256 <"$1")"
	fi
	if [ "${actual%% *}" != "$2" ]; then
		echo "Checksum verification failed: $1" >&2
		return 1
	fi
}

ensure_zip_extractor() {
	if command -v unzip >/dev/null 2>&1 || command -v python3 >/dev/null 2>&1; then
		return
	fi
	if [ "${os}" = linux ] && command -v apt-get >/dev/null 2>&1; then
		sudo apt-get update
		sudo apt-get install -y unzip
	else
		echo 'Install unzip, then run this installer again.' >&2
		return 1
	fi
}

extract_zip() {
	if command -v unzip >/dev/null 2>&1; then
		unzip -q "$1" -d "$2"
	else
		python3 -m zipfile -e "$1" "$2"
	fi
}

record_bootstrap_binary() {
	local digest
	if command -v sha256sum >/dev/null 2>&1; then
		digest="$(sha256sum <"${bootstrap_bin}/$1")"
	else
		digest="$(shasum -a 256 <"${bootstrap_bin}/$1")"
	fi
	printf '%s %s\n' "${digest%% *}" "$1" >>"${cleanup_manifest}"
}

install_op() {
	if command -v op >/dev/null 2>&1; then return; fi
	local version=2.41.1 checksum archive
	case "${os}_${arch}" in
	linux_amd64) checksum=e52476700cba9202ac7469bdfb2648ecdbf3438ac85822010f77230139e74966 ;;
	linux_arm64) checksum=89abd60c17d5c614066c20e6abed816449eb018c5e0679ed63d57071c7bee85e ;;
	darwin_amd64) checksum=e77fc9a8ebb23c176fed7c56ea6e4a7184d2b89957e9a5d9a2feb724e7e0574b ;;
	darwin_arm64) checksum=2289771b68b521ee3dc1d63a013a6a1c5691e0c53e4c4fe79af8042b6ad3c7f5 ;;
	esac
	ensure_zip_extractor
	archive="op_${os}_${arch}_v${version}.zip"
	curl -fsSL "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/${archive}" -o "${workdir}/${archive}"
	verify_sha256 "${workdir}/${archive}" "${checksum}"
	extract_zip "${workdir}/${archive}" "${workdir}/op"
	install -m 755 "${workdir}/op/op" "${bootstrap_bin}/op"
	record_bootstrap_binary op
}

install_gh() {
	if command -v gh >/dev/null 2>&1; then return; fi
	local version=2.103.2 checksum package archive
	case "${os}_${arch}" in
	linux_amd64) checksum=62ccf747115ddc61237efffdde66a3c8f70ba249433dc64f70801089b59c59c8 ;;
	linux_arm64) checksum=4c3e99a50bd8b181a3fe9d69b25dd978bac768148d88f01507c6b4d1ef61a443 ;;
	darwin_amd64) checksum=2dc7f1fc4761f96732995f6e4f4c6b4d705f2635da4126620c8b30eaa67b9c98 ;;
	darwin_arm64) checksum=5416000f5d17580a187339e0c4068a01ca5c87f7d4fe6ca64933696f967bc418 ;;
	esac
	if [ "${os}" = linux ]; then
		package="gh_${version}_linux_${arch}"
		archive="${package}.tar.gz"
	else
		package="gh_${version}_macOS_${arch}"
		archive="${package}.zip"
		ensure_zip_extractor
	fi
	curl -fsSL "https://github.com/cli/cli/releases/download/v${version}/${archive}" -o "${workdir}/${archive}"
	verify_sha256 "${workdir}/${archive}" "${checksum}"
	if [ "${os}" = linux ]; then
		tar -xzf "${workdir}/${archive}" -C "${workdir}"
	else
		extract_zip "${workdir}/${archive}" "${workdir}"
	fi
	install -m 755 "${workdir}/${package}/bin/gh" "${bootstrap_bin}/gh"
	record_bootstrap_binary gh
}

authenticate() {
	local accounts
	if [ "${mode}" = --setup-private ]; then
		accounts="$(op account list --format=json)"
		if [[ "${accounts}" =~ ^[[:space:]]*\[[[:space:]]*\][[:space:]]*$ ]]; then
			op account add
		fi
		# chezmoi signs in itself so its process retains the session token.
	fi
	if ! gh auth status --hostname github.com --active >/dev/null 2>&1; then
		gh auth login --hostname github.com --git-protocol https --web
	fi
}

main() (
	set -euo pipefail
	umask 077
	local os arch bootstrap_bin cleanup_manifest workdir wrapper_source mode="${1:---setup}"
	case "${mode}" in
	--setup|--setup-private|--download-only) ;;
	*) echo "Unknown bootstrap mode: ${mode}" >&2; return 1 ;;
	esac
	detect_platform
	bootstrap_bin="${HOME}/.local/bin"
	cleanup_manifest="${XDG_STATE_HOME:-${HOME}/.local/state}/dotfiles/bootstrap/cleanup"
	mkdir -p "${bootstrap_bin}" "$(dirname "${cleanup_manifest}")"
	wrapper_source="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bootstrap-op.sh"
	install -m 755 "${wrapper_source}" "$(dirname "${cleanup_manifest}")/op"
	export PATH="${HOME}/.nix-profile/bin:${bootstrap_bin}:${PATH}"
	if [ "${CHEZMOI_COMMAND:-}" = init ] && [ "${DOTFILES_CHEZMOI_EXECUTABLE:-}" = "${bootstrap_bin}/chezmoi" ] && [ -f "${bootstrap_bin}/chezmoi" ]; then
		record_bootstrap_binary chezmoi
	fi
	workdir="$(mktemp -d)"
	trap 'rm -rf "${workdir}"' EXIT
	install_op
	install_gh
	if [ "${mode}" = --download-only ]; then
		op --version
		gh --version
		return
	fi
	authenticate
)

if [[ "${BASH_SOURCE[0]:-$0}" == "$0" ]]; then
	main "$@"
fi
