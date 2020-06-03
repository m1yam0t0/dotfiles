#!/usr/bin/env bash

# install asdf
ASDF_DIR="${HOME}/.asdf"
if [ ! -d "${ASDF_DIR}" ]; then
    git clone https://github.com/asdf-vm/asdf.git ${ASDF_DIR}
fi

cd "${ASDF_DIR}"
git checkout "$(git describe --abbrev=0 --tags)"

cd -
source ${ASDF_DIR}/asdf.sh

# install asdf plugins
ASDF_PLUGINS="$(cat ${HOME}/.tool-versions | awk '{print $1}' | perl -pe 's/\n/ /g')"
for p in ${ASDF_PLUGINS}
do
    asdf plugin add $p
done
asdf install
asdf reshim

# install some packages
pip install -U pip
pip install pynvim flake8 black

GO111MODULE=on go get golang.org/x/tools/gopls@latest

npm install -g yarn neovim bash-language-server dockerfile-language-server-nodejs

