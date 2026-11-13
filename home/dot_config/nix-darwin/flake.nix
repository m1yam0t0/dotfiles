{
  description = "nix-darwin configuration of m1yam0t0";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nix-darwin, ... }:
    let
      lib = nixpkgs.lib;
      # Nixpkgs 26.11 dropped support for x86_64-darwin.
      systems = [
        "aarch64-darwin"
      ];
      mkDarwin = system: nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          { nixpkgs.hostPlatform = system; }
        ];
      };
    in
    {
      packages = lib.genAttrs systems (system: {
        darwin-rebuild = nix-darwin.packages.${system}.darwin-rebuild;
      });

      darwinConfigurations = builtins.listToAttrs (map (system: {
        name = "m1yam0t0-${system}";
        value = mkDarwin system;
      }) systems);
    };
}
