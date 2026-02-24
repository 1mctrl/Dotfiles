{
  description = "Home Manager configuration of icon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-prismlauncher.url = "github:nixos/nixpkgs";
    nixpkgs-prismlauncher.inputs.nixpkgs.follows = "nixpkgs";

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-prismlauncher, home-manager, nixGL, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            prismlauncher-unwrapped =
              nixpkgs-prismlauncher.legacyPackages.${system}.prismlauncher-unwrapped;
          })
        ];
      };
    in {
      homeConfigurations.icon =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit nixGL system;
          };
          modules = [ ./home.nix ];
        };
    };
}
