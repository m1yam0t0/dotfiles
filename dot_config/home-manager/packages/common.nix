{ pkgs, ... }:

{
  home.packages = [
    pkgs.bat
    pkgs.chezmoi
    pkgs.delta
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.git
    pkgs.gh
    pkgs.ghq
    pkgs.jnv
    pkgs.jq
    pkgs.mise
    pkgs.neovim
    pkgs.ripgrep
    pkgs.viddy
    pkgs.yq-go
  ];
}
