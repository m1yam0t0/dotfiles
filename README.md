# dotfiles

[![Installation test](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml/badge.svg)](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml)

m1yam0t0's dotfiles. managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Install

### MacOS, Ubuntu

```sh
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init m1yam0t0 --apply
rm -f ${HOME}/.local/bin/chezmoi
```

On private machines, a source-state hook installs Nix and a bootstrap 1Password
CLI before chezmoi renders templates that read secrets. Sign in to 1Password
when prompted. Home Manager manages the regular CLI installation afterward.

If an earlier installation stopped with `op: executable file not found`, update
the source checkout to include this fix, then regenerate the chezmoi config and
resume the installation:

```sh
~/.local/bin/chezmoi init --apply
```

### Windows

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b $HOME/.local/bin -- init m1yam0t0 --apply"
rm $HOME/.local/bin/chezmoi.exe
```
