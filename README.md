# dotfiles

[![Installation test](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml/badge.svg)](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml)

m1yam0t0's dotfiles. managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Install

### MacOS, Ubuntu

```sh
bash -c "$(curl -fsLS https://raw.githubusercontent.com/m1yam0t0/dotfiles/main/.install.sh)" --
```

The installer downloads missing `chezmoi`, `op`, and `gh` binaries, configures
1Password and GitHub authentication, then runs `chezmoi init --apply`. Enter
your 1Password account details and follow GitHub's browser authentication when
prompted. Existing installations and authenticated accounts are reused.

The 1Password session is passed to chezmoi through the process environment.
Initial setup binaries are stored in
`${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/bootstrap/bin`, which is added
only to the installer's PATH. Home Manager manages the regular packages after
the initial setup. ZIP files are extracted with `unzip` or Python 3. On Ubuntu,
the installer installs `unzip` with sudo if neither extractor is available.

To install from a branch, download the script from the same branch and pass
`--branch` to chezmoi:

```sh
bash -c "$(curl -fsLS https://raw.githubusercontent.com/m1yam0t0/dotfiles/refs/heads/m1yam0t0/fix-linux-installation/.install.sh)" -- \
  --branch m1yam0t0/fix-linux-installation
```

From an existing source checkout, run `bash .install.sh --branch <branch>`.
Maintainers can use `bash .install.sh --download-only` to check binary downloads
without authenticating or applying dotfiles. The shell installer supports
Linux and macOS on amd64 and arm64. The Windows PowerShell setup is separate.

### Windows

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b $HOME/.local/bin -- init m1yam0t0 --apply"
rm $HOME/.local/bin/chezmoi.exe
```
