{ pkgs, fetchFromGitHub, callPackage }:
let
  golangci_lint_ls = callPackage ../golangci_lint_ls { };
in with pkgs; {
  nvim-lspconfig = vimPlugins.nvim-lspconfig.overrideAttrs
    (final: prev: { buildInputs = [ golangci_lint_ls ]; });
  catppuccin-nvim = vimUtils.buildNeovimPluginFrom2Nix {
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
}
