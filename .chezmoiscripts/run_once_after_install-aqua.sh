#!/usr/bin/env bash
set -euo pipefail

AQUA_INSTALLER_VERSION="v4.0.2"
AQUA_INSTALLER_SHA256="98b883756cdd0a6807a8c7623404bfc3bc169275ad9064dc23a6e24ad398f43d"
AQUA_VERSION="v2.43.1"

if command -v aqua >/dev/null 2>&1; then
	echo "aqua is already installed."
	exit 0
fi

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

installer_url="https://raw.githubusercontent.com/aquaproj/aqua-installer/${AQUA_INSTALLER_VERSION}/aqua-installer"
installer_path="${workdir}/aqua-installer"

if command -v curl >/dev/null 2>&1; then
	curl -sSfL -o "$installer_path" "$installer_url"
elif command -v wget >/dev/null 2>&1; then
	wget -qO "$installer_path" "$installer_url"
else
	echo "curl or wget is required to install aqua." >&2
	exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
	echo "${AQUA_INSTALLER_SHA256}  ${installer_path}" | sha256sum -c -
elif command -v shasum >/dev/null 2>&1; then
	echo "${AQUA_INSTALLER_SHA256}  ${installer_path}" | shasum -a 256 -c -
else
	echo "sha256sum or shasum is required to verify aqua-installer." >&2
	exit 1
fi

chmod +x "$installer_path"
"$installer_path" -v "$AQUA_VERSION"
