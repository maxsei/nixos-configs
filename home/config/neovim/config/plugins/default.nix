{
  imports = [
    ./colors.nix
    ./telescope.nix
    ./treesitter.nix
    ./harpoon.nix
    ./undotree.nix
    ./fugitive.nix
    ./lsp.nix
  ];

  plugins.web-devicons.enable = true;
}
