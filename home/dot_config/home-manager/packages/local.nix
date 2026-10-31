{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
