{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
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
      sops-nix,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      {
        homeConfigurations = {
          mschulte = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ rust-overlay.overlays.default ];
            };
            extraSpecialArgs = { inherit inputs; };
            modules = [ ./home/users/mschulte ];
          };
        };

        nixosConfigurations = {
          thinkpad-t440p = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [
              (
                { pkgs, lib, ... }:
                {
                  nixpkgs.overlays = [ rust-overlay.overlays.default ];
                  nixpkgs.config = {
                    permittedInsecurePackages = [
                      "python-2.7.18.12"
                      "electron-24.8.6"
                    ];
                    allowUnfreePredicate =
                      pkg:
                      builtins.elem (lib.getName pkg) [
                        "obsidian"
                        "slack"
                        "ngrok"
                        "claude-code"
                      ];
                  };
                }
              )
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; };
                home-manager.users.mschulte = import ./home/users/mschulte;
              }
              ./system/hosts/thinkpad-t440p/configuration.nix
            ];
          };
          home-server = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              sops-nix.nixosModules.sops
              ./system/hosts/home-server/configuration.nix
            ];
          };
        };
      }
    );
}
