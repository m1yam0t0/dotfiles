{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-cli
    bat
    chezmoi
    curl
    delta
    eza
    fd
    fzf
    git
    gh
    ghq
    jnv
    jq
    mise
    neovim
    ripgrep
    viddy
    yq-go
  ];
}
