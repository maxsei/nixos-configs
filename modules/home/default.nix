{ pkgs, ... }:

{
  imports = [
    ./modules/vim.nix      # Import Vim module
    ./modules/alacritty.nix # Import Alacritty module
  ];

  # Additional Home Manager configurations can go here
}
