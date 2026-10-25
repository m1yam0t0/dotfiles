{
  description = "Home Manager configuration of m1yam0t0";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      unfreePackageNames = [
        "1password-cli"
      ];
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePackageNames;
        };
        modules = [ ./home.nix ];
      };
    in
    {
      packages = lib.genAttrs systems (system: {
        home-manager = home-manager.packages.${system}.home-manager;
      });

      homeConfigurations = builtins.listToAttrs (map (system: {
        name = "m1yam0t0-${system}";
        value = mkHome system;
      }) systems) // {
        m1yam0t0 = mkHome "x86_64-linux";
      };
    };
}
