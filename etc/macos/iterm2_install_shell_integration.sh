#!/usr/bin/env sh

# Get Install Script
TMP_FILE="$(mktemp 2> /dev/null)"
curl -sL https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh > ${TMP_FILE}

# Create directory for iterm2
ITERM_DIR="${HOME}/.iterm2"
if [ ! -d ${ITERM_DIR} ]; then
    mkdir -p ${ITERM_DIR}
fi

# Download script
SHELL_TYPE="${SHELL##*/}"
ITERM_SCRIPT="${ITERM_DIR}/iterm2_shell_integration.${SHELL_TYPE}"
if [ -f ${ITERM_SCRIPT} ]; then
    echo "Shell integration script is already downloaded."
else
    echo "Downloading shell integration script..."
    curl -SsL "https://iterm2.com/shell_integration/${SHELL_TYPE}" > "${ITERM_SCRIPT}"
    chmod +x "${ITERM_SCRIPT}"
fi

# Download utilities
UTILITIES="$(grep 'UTILITIES=' ${TMP_FILE} | sed -e "s/^.*(\(.*\)).*$/\1/")"
for u in ${UTILITIES}
do
    if [ -f ${ITERM_DIR}/$u ]; then
        echo "$u is already downloaded."
        continue
    fi
    echo "Downloading $u..."
    curl -SsL "https://iterm2.com/utilities/$u" > ~/.iterm2/$u
    chmod +x ~/.iterm2/$u
done

# Delete Install Script
rm -f ${TMP_FILE}
