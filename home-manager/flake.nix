{
  description = "Home Manager configuration of icon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixGL, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
(final: prev: {
  prismlauncher-unwrapped =
    prev.prismlauncher-unwrapped.overrideAttrs (old: {
      version = "9.4";

      src = prev.fetchFromGitHub {
        owner = "PrismLauncher";
        repo = "PrismLauncher";
        rev = "9.4";
        fetchSubmodules = true;
        hash = "sha256-Ndt0op00byJL2Xk2oJIMEwu8uVv0PTL9mHDk8kH3r/c=";
      };

      buildInputs = old.buildInputs ++ [
        prev.qt6.qt5compat
      ];
    });
})
      ];
    };
  in {
    homeConfigurations.icon =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit nixGL system; };
        modules = [ ./home.nix ];
      };
  };
}
