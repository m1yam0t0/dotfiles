#!/usr/bin/env bash

# load environment variables
# shellcheck disable=SC1091
source "${HOME}/.zshenv"

# Check login status.
# If you are no logged into GitHub. Run gh auth login.
gh auth status
ret=$?
if [ $ret -ne 0 ]; then
    gh auth login
else
    echo "You have already logged in to GitHub."
fi

# If you have already installed extension. Installation is skipped.
## extension-list format example
## gh poi  seachicken/gh-poi  v0.9.5
installed=$(gh extension list)
while read -r line; do
    read -r -a ext <<<"$line"
    repo=${ext[2]}
    grep "${repo}" <<<"$installed" >/dev/null
    ret=$?
    if [ $ret -ne 0 ]; then
        gh extension install "${repo}"
    else
        echo "${repo} has already installed."
    fi
done <"${XDG_CONFIG_HOME}/gh/extension-list"
