# dotfiles

m1yam0t0's dotfiles.

## Install

```sh
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply m1yam0t0
rm -rf $(pwd)/bin
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

