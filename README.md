# dotfiles

[![test](https://github.com/m1yam0t0/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/m1yam0t0/dotfiles/actions/workflows/test.yml)

m1yam0t0's dotfiles. managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Install

### MacOS, Ubuntu

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ${HOME}/.local/bin init --apply m1yam0t0
rm -f ${HOME}/.local/bin/chezmoi
```

### Windows

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
'$params = "-b $HOME/.local/bin init --apply m1yam0t0"', (irm https://get.chezmoi.io/ps1) | powershell -c -
rm $HOME/.local/bin/chezmoi.exe
```
