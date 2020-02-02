#!/usr/bin/env sh

SHELL_PATH='/usr/local/bin/zsh'

if [ "${SHELL}" != "${SHELL_PATH}" ]; then
    # /etc/shells
    if [ -z "$( grep "${SHELL_PATH}" /etc/shells )" ]; then
        sudo echo "${SHELL_PATH}" | sudo tee -a /etc/shells
    fi

    sudo chsh -s $(which zsh) ${USER}
    exec ${SHELL_PATH} -l
else
    echo "${USER}'s shell is already changed"
fi
