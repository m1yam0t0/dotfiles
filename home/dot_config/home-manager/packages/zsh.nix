{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-autosuggestions
  ];
}
