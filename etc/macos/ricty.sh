#!/usr/bin/env sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
RICTY_FONT_DIR="/usr/local/opt/ricty/share/fonts"
USER_FONT_DIR="${HOME}/Library/Fonts"

IFS_bak=${IFS}
IFS=$'\n'

fonts=$(ls -1 ${RICTY_FONT_DIR}/Ricty*.ttf)
for f in ${fonts};
do
    font_file=$(basename "$f")
    ${SCRIPT_DIR}/ricty_fix-backquote.pe "$f" "${USER_FONT_DIR}/${font_file}"
done

IFS=${IFS_bak}

fc-cache -vf

