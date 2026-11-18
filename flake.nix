{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    hermes-agent.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      fenix,
      flake-utils,
      sops-nix,
      hermes-agent,
      ...
    }@inputs:
    nixpkgs.lib.recursiveUpdate
    (flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "obsidian"
            "slack"
            "ngrok"
            "claude-code"
          ];
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config = { inherit allowUnfreePredicate; };
        };
      in
      {
        homeConfigurations =
          let
            mkHome =
              user:
              home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                  inherit system;
                  overlays = [ fenix.overlays.default ];
                  config = { inherit allowUnfreePredicate; };
                };
                extraSpecialArgs = { inherit inputs pkgs-unstable; };
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
            specialArgs = { inherit inputs pkgs-unstable; };
            modules = [
              {
                environment.etc."current-flake".source = inputs.self;
              }
              (
                { pkgs, lib, ... }:
                {
                  nixpkgs.overlays = [ fenix.overlays.default ];
                  nixpkgs.config = {
                    permittedInsecurePackages = [
                      "python-2.7.18.12"
                      "electron-24.8.6"
                    ];
                    inherit allowUnfreePredicate;
                  };
                }
              )
              sops-nix.nixosModules.sops
              hermes-agent.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
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
      }
    ))
    {
      nixosConfigurations.annon = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          (
            { lib, ... }:
            {
              boot.supportedFilesystems.zfs = lib.mkForce false;
            }
          )
          sops-nix.nixosModules.sops
          ./system/hosts/annon/configuration.nix
        ];
      };

      nixosConfigurations.raspberry-pi-4-installer = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          (
            { pkgs, lib, ... }:
            {
              system.stateVersion = "26.05";

              boot.supportedFilesystems.zfs = lib.mkForce false;

              documentation.enable = false;
              documentation.nixos.enable = false;

              environment.systemPackages = with pkgs; [
                lf
                neovim
                ssh-to-age
              ];

              networking.firewall.enable = false;

              users.mutableUsers = false;
              users.users.root.password = "root";
              services.openssh.enable = true;
              services.openssh.settings.PermitRootLogin = "yes";
              services.openssh.settings.PasswordAuthentication = true;
              services.openssh.settings.KbdInteractiveAuthentication = true;
            }
          )
        ];
      };

      packages.aarch64-linux.raspberry-pi-4-installer-sd-image =
        self.nixosConfigurations.raspberry-pi-4-installer.config.system.build.sdImage;
    };
}
