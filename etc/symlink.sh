#!/usr/bin/env zsh

# path of dotfiles
DOTPATH="${HOME}/.dotfiles"

# symlink ${DOTFILES} -> ${HOME}
DOTFILES=($(find ${DOTPATH} -mindepth 1 -maxdepth 1 | sed 's#^.*/##'))
DOTIGNORE=".config .git .github .gitignore etc LICENSE Makefile README.md"
for f in ${DOTFILES}
do
    [ -n "$(echo "${DOTIGNORE}" | grep $f)" ] && continue
    rm -rf "${HOME}/$f"
    ln -snfv "${DOTPATH}/$f" "${HOME}/$f"
done

# create ${XDG_CONFIG_HOME}
XDG_CONFIG_HOME=${HOME}/.config
mkdir -p ${XDG_CONFIG_HOME}

# symlink ${DOTFILES} -> ${XDG_CONFIG_HOME}
CONFIGFILES=($(find ${DOTPATH}/.config -mindepth 1 -maxdepth 1 | sed 's#^.*/##'))
for f in ${CONFIGFILES}
do
    rm -rf "${XDG_CONFIG_HOME}/$f"
    ln -snfv "${DOTPATH}/.config/$f" "${XDG_CONFIG_HOME}/$f"
done

