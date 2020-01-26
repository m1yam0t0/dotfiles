#!/usr/bin/env sh

if [ ! -d ~/.zinit ]; then
    mkdir ~/.zinit
    git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
else
    echo "zinit is already installed"
fi
