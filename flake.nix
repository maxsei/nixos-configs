{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fenix = {
      url = "github:nix-community/fenix";
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
      fenix,
      flake-utils,
      sops-nix,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystemPassThrough (system: {
      homeConfigurations =
        let
          mkHome =
            user:
            home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs {
                inherit system;
                overlays = [ fenix.overlays.default ];
              };
              extraSpecialArgs = { inherit inputs; };
              modules = [ ./home/users/${user} ];
            };
        in
        {
          mschulte = mkHome "mschulte";
          mschulte71 = mkHome "mschulte71";
        };

      nixosConfigurations = {
        thinkpad-t440p = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            (
              { pkgs, lib, ... }:
              {
                nixpkgs.overlays = [ fenix.overlays.default ];
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
              home-manager.users.mschulte71 = import ./home/users/mschulte71;
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
    });
}
