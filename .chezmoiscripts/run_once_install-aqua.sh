#!/usr/bin/env bash

if [ ! -d "${AQUA_ROOT_DIR:-$HOME/.local/share/aquaproj-aqua}" ]; then
    curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/main/aqua-installer | bash
else
    echo "auqa is already installed."
fi

