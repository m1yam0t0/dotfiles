#!/usr/bin/env zsh

# load environment variables from zshenv
source ${HOME}/.zshenv

ZI_DIR="${XDG_CACHE_HOME}/zi"

if [ ! -d ${ZI_DIR} ]; then
    mkdir ${ZI_DIR}
    git clone https://github.com/z-shell/zi.git ${ZI_DIR}/bin
else
    echo "zi is already installed"
fi
