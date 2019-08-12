#!/usr/bin/env bash

# install developer tool
xcode-select -p > /dev/null

if [[ $? != 0 ]]; then
    echo "install developer tool"
    xcode-select --install
else
    echo "developer tool is already installed"
fi

# install homebrew
if !(type brew > /dev/null 2>&1); then
    echo "install homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "homebrew is already installed"
fi

