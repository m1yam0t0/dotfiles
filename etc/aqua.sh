#!/usr/bin/env zsh

# load environment variables from zshenv
source ${HOME}/.zshenv

# install aqua
if [ ! -d "${AQUA_ROOT_DIR}" ]; then
    curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/main/aqua-installer | bash
else
    echo "auqa is already installed."
fi

# install packages
aqua i -a

