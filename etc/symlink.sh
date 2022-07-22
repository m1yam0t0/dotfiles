#!/usr/bin/env zsh

# path of dotfiles
DOTPATH="${HOME}/.dotfiles"
DOTFILES=($(find $DOTPATH -mindepth 1 -maxdepth 1 | sed 's#^.*/##'))
DOTIGNORE=".git .github .gitignore etc LICENSE Makefile README.md"

# symlink $DOTFILES -> $home
for f in $DOTFILES
do
    [ -n "$(echo "${DOTIGNORE}" | grep $f)" ] && continue
    rm -rf "${HOME}/.$f"
    ln -snfv "${DOTPATH}/$f" "${HOME}/.$f"
done
