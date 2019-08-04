#!/bin/sh

# path of dotfiles
DOTPATH=$HOME/.dotfiles/dotfiles
DOTFILES=$(find $HOME/.dotfiles/dotfiles -depth 1 | sed 's#^.*/##')

# symlink $DOTFILES -> $home
for f in $DOTFILES
do
    [ "${f}" = ".git" ] || [ "${f}" = ".gitignore" ] && continue
    ln -snfv "${DOTPATH}/$f" $HOME/"$f"
done
