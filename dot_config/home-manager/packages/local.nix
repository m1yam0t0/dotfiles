{ pkgs, ... }:

{
  home.packages = [
    pkgs._1password-cli
    pkgs.age
    pkgs.cilium-cli
    pkgs.fluxcd
    pkgs.kind
    pkgs.krew
    pkgs.kubeconform
    pkgs.kubectl
    pkgs.kubent
    pkgs.kubernetes-helm
    pkgs.kustomize
    pkgs.sops
    pkgs.stern
  ];
}
