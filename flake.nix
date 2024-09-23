{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
  inputs.neovim-git.url = "github:neovim/neovim?dir=contrib";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        thinkpad-t440p = nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              # home-manager.overlays.default
            ];
            config = {
              permittedInsecurePackages = [ "python-2.7.18.8" "electron-24.8.6" ];
              allowUnfreePredicate = pkg:
                builtins.elem (lib.getName pkg) [
                  "obsidian"
                  "slack"
                  "ngrok"
                  "google-chrome"
                ];
            };
          };
          # specialArgs = { inherit inputs; };
          modules = [ ./hosts/thinkpad-t440p/configuration.nix ];
        };
      };
    };
}
