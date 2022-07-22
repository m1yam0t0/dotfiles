#!/usr/bin/env sh

REPO_HTTP_URL='https://github.com/m1yam0t0/dotfiles.git'
REPO_SSH_URL='git@github.com:m1yam0t0/dotfiles.git'
TARBALL_URL='https://github.com/m1yam0t0/dotfiles/archive/master.tar.gz'
DOTPATH="${HOME}/.dotfiles"

# get dotfiles
GIT='/usr/bin/git'
if [ -f "${GIT}" ]; then
    git clone ${REPO_HTTP_URL} ${DOTPATH}
    cd ${DOTPATH}
    git remote set-url origin ${REPO_SSH_URL}
    cd -
else
    # if you cannot use git, get & extract tarball
    curl -L ${TARBALL_URL} | tar -xzv
    mv -f dotfiles-master ${DOTPATH}
fi
