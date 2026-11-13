{ pkgs, ... }:

let
  # git 2.56.1 (security fixes) is not in nixpkgs yet. Remove this override once it lands.
  git = pkgs.git.overrideAttrs (old: rec {
    version = "2.56.1";
    src = pkgs.fetchurl {
      url = "https://www.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
      hash = "sha256-8LC/iSZLm9LhxkA2PnUpZDmJ2nYoFgBHPFB0XNNKYH8=";
    };
  });
in
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
    git # overridden above (let bindings take precedence over `with pkgs`)
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
