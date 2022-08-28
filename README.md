# dotfiles

m1yam0t0's dotfiles.

## Install

Linux/Unix

```sh
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b ${HOME}/.local/bin init --apply m1yam0t0
rm -rf $(pwd)/.local/bin/chezmoi
```

Windows

```pwsh
'$params = "-b ~/.local/bin init --apply m1yam0t0"', (irm https://chezmoi.io/get.ps1) | powershell -c -
```

## Maintenance

Pull and apply latest dotfiles

```sh
chezmoi update
```

Add files

```sh
chezmoi add ${file}
```

Edit files

```sh
chezmoi edit ${file}
```

Simulate template file

```sh
chezmoi execute-template --init < ${file}
```

Reflect local modified files

```sh
chezmoi re-add
```
