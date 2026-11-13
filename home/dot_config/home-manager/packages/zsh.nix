{ pkgs, ... }:

let
  # Not packaged in nixpkgs. https://github.com/romkatv/zsh-bench
  zsh-bench = pkgs.stdenvNoCC.mkDerivation {
    pname = "zsh-bench";
    version = "0-unstable-2026-04-27";

    src = pkgs.fetchFromGitHub {
      owner = "romkatv";
      repo = "zsh-bench";
      rev = "28b1b1bc888159f0a2cf50f9d29381758341aba1";
      hash = "sha256-dsHGpDTweDqJdLhO/9th2kDt56crfjqkTKBilEi9RaY=";
    };

    # Keep `#!/usr/bin/env zsh` so that the script runs with the login shell's zsh.
    dontPatchShebangs = true;

    # zsh-bench reads internal/ and configs/ next to the script, so install the
    # whole tree and link the entry point. It writes only to $TMPDIR.
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/zsh-bench $out/bin
      cp -r . $out/share/zsh-bench
      ln -s $out/share/zsh-bench/zsh-bench $out/bin/zsh-bench
      runHook postInstall
    '';
  };
in
{
  home.packages = with pkgs; [
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-bench
  ];
}
