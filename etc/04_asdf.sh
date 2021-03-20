#!/usr/bin/env sh

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

# Import the Node.js release team's OpenPGP keys to main keyring
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'

# install each plugin
asdf install
asdf reshim
