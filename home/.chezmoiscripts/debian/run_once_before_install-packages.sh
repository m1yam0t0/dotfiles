#!/usr/bin/env bash
set -euo pipefail

# NOTE: this is workaround for GitHub Actions runners. see below issue.
# https://github.com/actions/runner-images/issues/7192
# grub-efi-amd64-signed fails to configure on runners (BIOS boot), so skip upgrading it.
if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
	sudo apt-mark hold grub-efi-amd64-signed
fi

# updgrade to latest packages
sudo apt update
sudo apt upgrade -y

# install packages that still need OS-level setup on Debian/Ubuntu.
sudo apt install -y \
	ca-certificates \
	locales \
	zsh
