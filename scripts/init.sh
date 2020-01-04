#!/usr/bin/env bash

REPO_URL=https://github.com/m1yam0t0/dotfiles
TARBALL_URL=${REPO_URL}/archive/master.tar.gz
DOTFILES_PATH=~/.dotfiles

# get dotfiles
if type git > /dev/null 2>&1; then
    git clone "${REPO_URL}.git" ${DOTFILES_PATH}
else
    # if you cannot use git, get & extract tarball
    curl -L ${TARBALL_URL} | tar xzv
    mv -f dotfiles-master ${DOTFILES_PATH}
fi
