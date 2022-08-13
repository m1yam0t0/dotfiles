#!/usr/bin/env sh

SHELL_PATH="$(which zsh)"
INSECURE_PATH='/usr/local/share/zsh /usr/local/share/zsh/site-functions'

# fix insecure directories
sudo chmod -R 755 ${INSECURE_PATH}

if [ "${SHELL}" != "${SHELL_PATH}" ]; then
    # Add SHELL_PATH to /etc/shells
    if [ -z "$(grep "${SHELL_PATH}" /etc/shells)" ]; then
        sudo echo "${SHELL_PATH}" | sudo tee -a /etc/shells
    fi

    # change default shell
    sudo chsh -s ${SHELL_PATH} ${USER}
    exec ${SHELL_PATH} -l
else
    echo "${USER}'s shell is already changed"
fi
