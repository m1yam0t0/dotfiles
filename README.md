# dotfiles

[![Installation test](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml/badge.svg)](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml)

m1yam0t0's dotfiles. managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Install

### MacOS, Ubuntu

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ${HOME}/.local/bin init m1yam0t0 --apply
rm -f ${HOME}/.local/bin/chezmoi
```

### Windows

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
'$params = "-b $HOME/.local/bin init m1yam0t0 --apply"', (irm https://get.chezmoi.io/ps1) | powershell -c -
rm $HOME/.local/bin/chezmoi.exe
```
