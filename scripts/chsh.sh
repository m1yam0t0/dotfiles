#!/usr/bin/env sh

if [ $SHELL != $(which zsh) ]; then
    sudo chsh -s $(which zsh) $USER
else
    echo "${USER}'s shell is already changed"
fi
