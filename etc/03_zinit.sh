#!/usr/bin/env sh

if [ ! -d ~/.zplugin ]; then
    mkdir ~/.zplugin
    git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
else
    echo "zplugin is already installed"
fi
