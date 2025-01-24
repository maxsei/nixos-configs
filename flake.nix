{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-git.url = "github:neovim/neovim?dir=contrib";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      rust-overlay,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # Utilize flake-utils to determine the system
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            # home-manager.overlays.default
          ];
          config = {
            permittedInsecurePackages = [
              "python-2.7.18.8"
              "electron-24.8.6"
            ];
            allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "obsidian"
                "slack"
                "ngrok"
                "google-chrome"
              ];
          };
        };
      in
      {
        packages = {

          nixosConfigurations = {
            thinkpad-t440p = nixpkgs.lib.nixosSystem {
              inherit system pkgs;
              modules = [
                (
                  { pkgs, ... }:
                  {
                    nixpkgs.overlays = [ rust-overlay.overlays.default ];
                  }
                )
                ./hosts/thinkpad-t440p/configuration.nix
              ];
            };
          };
        };

      }
    );
}
