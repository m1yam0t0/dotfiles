# dotfiles

[![Installation test](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml/badge.svg)](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml)

m1yam0t0's dotfiles. managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Install

### MacOS, Ubuntu

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io/lb)" -- -b "$HOME/.local/bin" init m1yam0t0 --apply
```

The chezmoi installer places its binary in `~/.local/bin`. A
`read-source-state.pre` hook downloads missing `op` and `gh` binaries to the
same directory before secret templates are evaluated. The hook registers a
1Password account if needed and starts GitHub browser authentication. chezmoi
handles 1Password sign-in when reading secrets, so the session stays in the
process that needs it. Existing installations and configured accounts are reused.

The regular `.chezmoiscripts` then install Nix, activate Home Manager, and
update plugins. The final `run_after_zz_cleanup-bootstrap.sh` removes the
initial `chezmoi`, `op`, and `gh` binaries after verifying that Home Manager
installed all three replacements. It removes only recorded bootstrap binaries
whose checksums are unchanged. On failure, bootstrap files remain for retrying.
Future secret reads use Home Manager's `op` through a small wrapper in the
dotfiles state directory, which remains after binary cleanup.

ZIP files are extracted with `unzip` or Python 3. On Ubuntu, the hook installs
`unzip` with sudo if neither extractor is available. The hook and cleanup support
Linux and macOS on amd64 and arm64; Windows uses the separate setup below.

To install this branch:

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io/lb)" -- -b "$HOME/.local/bin" \
  init m1yam0t0 --branch m1yam0t0/fix-linux-installation --apply
```

To resume an interrupted setup, use `~/.local/bin/chezmoi init --apply`.
After successful cleanup, use Home Manager's `chezmoi` for subsequent applies.
Maintainers can use `bash .bootstrap-cli.sh --download-only` to test downloads
without configuring accounts.

### Windows

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b $HOME/.local/bin -- init m1yam0t0 --apply"
rm $HOME/.local/bin/chezmoi.exe
```
