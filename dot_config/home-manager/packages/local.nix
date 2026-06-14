{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-cli
    age
    cilium-cli
    fluxcd
    kind
    krew
    kubeconform
    kubectl
    kubent
    kubernetes-helm
    kustomize
    sops
    stern
  ];
}
