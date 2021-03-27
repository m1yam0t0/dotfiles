#!/usr/bin/env zsh

# load environment variables from zshenv
source ${HOME}/.zshenv

# install asdf
if [ ! -d "${ASDF_DIR}" ]; then
    git clone https://github.com/asdf-vm/asdf.git ${ASDF_DIR}
fi

cd "${ASDF_DIR}"
git checkout "$(git describe --abbrev=0 --tags)"

cd -
source ${ASDF_DIR}/asdf.sh

# install asdf plugins
ASDF_PLUGINS=($(cat ${HOME}/.tool-versions | awk '{print $1}' | tr '\n' ' '))
for p in ${ASDF_PLUGINS}
do
    asdf plugin add $p
done

# install each plugin
asdf install
asdf reshim
