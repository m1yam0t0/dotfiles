#!/usr/bin/env sh

# path of dotfiles
DOTPATH=$HOME/.dotfiles
DOTFILES=$(find $DOTPATH -depth 1 | sed 's#^.*/##')
DOTIGNORE=".git .github .gitignore etc LICENSE Makefile README.md"

# symlink $DOTFILES -> $home
for f in $DOTFILES
do
    [ -n "$(echo "${DOTIGNORE}" | grep $f)" ] && continue
    ln -snfv "${DOTPATH}/$f" $HOME/"$f"
done
