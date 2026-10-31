# dotfiles

[![Installation test](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml/badge.svg)](https://github.com/m1yam0t0/dotfiles/actions/workflows/check-installation.yml)

m1yam0t0's dotfiles. managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Repository layout

`.chezmoiroot` selects `home/` as the source state. Only entries in that
directory define files to place in the home directory.

```text
home/                 # dotfiles, chezmoi configuration, and .chezmoiscripts
scripts/              # bootstrap helpers and test scripts
.github/              # CI and repository configuration
.chezmoiroot          # contains: home
```

The bootstrap hook uses the repository's working-tree path to call
`scripts/bootstrap-cli.sh`. Files under `scripts/`, CI configuration, and
repository documentation are outside the source state and are not applied.

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

The regular `home/.chezmoiscripts` then install Nix, activate Home Manager, and
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
Maintainers can use `bash scripts/bootstrap-cli.sh --download-only` to test downloads
without configuring accounts.

After updating an existing checkout from the previous flat layout, run
`chezmoi init --apply` once to regenerate the hook paths in the configuration.
Subsequent updates can use `chezmoi apply` normally.

### Windows

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b $HOME/.local/bin -- init m1yam0t0 --apply"
rm $HOME/.local/bin/chezmoi.exe
```

After applying the dotfiles, PowerShell can manage GitHub CLI extensions with
`gh-ext install` and `gh-ext upgrade` (`gh-ext.ps1 install` also works).
Both commands use `~/.config/gh/extension-list`, or
`$env:XDG_CONFIG_HOME/gh/extension-list` when `XDG_CONFIG_HOME` is set.
`upgrade` also saves the installed extension repositories back to that list.

## GitHub Actions dependencies

Workflow action dependencies are pinned in `.github/workflows/actions.lock`.
After adding a workflow or changing a `uses:` reference, regenerate and verify
the lockfile, then commit it together with the workflow changes:

```sh
gh actions-lock
gh actions-lock --verify
```

To advance existing locked references to their current upstream commits, use
`gh actions-lock --relock` and review the resulting diff. The verify-lockfile
workflow checks dependencies on pull requests targeting `main` and pushes to
`main` without modifying the lockfile.
