# ...
{ pkgs ? import <nixpkgs> { }, lib, ... }:
let
  plugins-extra = (pkgs.callPackage ./plugins.nix { inherit pkgs; });
  plugins-extra-list =
    (builtins.filter lib.isDerivation (builtins.attrValues plugins-extra));
in pkgs.neovim.override {
  vimAlias = true;
  configure = {
    packages.myplugins = with pkgs.vimPlugins; {
      start = [
        zig-vim
        vim-nix
        vim-graphql
        vim-svelte
        ultisnips
        vim-snippets
        vim-fugitive
        nvim-autopairs
        # surround-nvim
        vim-commentary
        deoplete-nvim
        deoplete-lsp
        trouble-nvim
        nvim-treesitter ]
        ++ plugins-extra-list;
    };
    customRC = builtins.readFile (./vimrc);
  };
}
