# ...
{
  pkgs ? import <nixpkgs> {},
  ...
}:
let
  catppuccin-nvim-2022-09-29 = with pkgs; vimUtils.buildNeovimPluginFrom2Nix {
    pname = "catppuccin-nvim";
    version = "2022-09-29";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "nvim";
      rev = "v0.2.3";
      sha256 = "08n78bj1b6japw6lzalin157m6c6bayky2d8vg3w3my5lfnj6d7y";
    };
    meta.homepage = "https://github.com/catppuccin/nvim/";
  };
in
  pkgs.neovim.override {
    vimAlias = true;
    configure = {
      packages.myplugins = with pkgs.vimPlugins; {
        start = [
          # catppuccin-nvim
          catppuccin-nvim-2022-09-29
          vim-nix
          vim-commentary
        ];
      };
      customRC = builtins.readFile (./vimrc);
    };
  }
