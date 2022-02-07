{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.neovim-git.url = "github:neovim/neovim?dir=contrib";

  outputs = inputs: {

    nixosConfigurations.thinkpad-e15-gen2 = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Things in this set are passed to modules and accessible
      # in the top-level arguments (e.g. `{ pkgs, lib, inputs, ... }:`).
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ({ pkgs, ... }: {
        })
        ./configuration.nix
      ];
    };

  };
}
