# ...
{ pkgs ? import <nixpkgs> { }, lib, callPackage, fetchFromGitHub, vimPlugins
, vimUtils, ... }:
let
  # Custom vim plugins.
  nvim-lspconfig = vimPlugins.nvim-lspconfig.overrideAttrs (final: prev: {
    # TODO: figure out how to integrate other pkgs into the path of the vimrc
    buildInputs = [
      # golangci_lint_ls
      # python39Packages.pylsp-mypy
      # gopls
      # nodePackages.typescript-language-server
      # nodePackages.diagnostic-languageserver
      # rnix-lsp
    ];
  });
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
  vim-astro = vimUtils.buildNeovimPluginFrom2Nix {
    pname = "vim-astro";
    version = "2022-08-24";
    src = fetchFromGitHub {
      owner = "wuelnerdotexe";
      repo = "vim-astro";
      rev = "34732be5e9a5c28c2409f4490edf92d46d8b55a9";
      sha256 = "1ild33hxiphj0z8b4kpcad4rai7q7jd0lsmhpa30kfgmyj5kh90z";
    };
  };
  # Tree sitter plugins.
  tree-sitter-astro =
    (callPackage <nixos/pkgs/development/tools/parsing/tree-sitter/grammar.nix>
      { } {
        language = "astro";
        version = pkgs.tree-sitter.version;
        source = pkgs.fetchFromGitHub {
          owner = "virchau13";
          repo = "tree-sitter-astro";
          rev = "a1f66bf72ed68b87f779bce9a52e5c6521fc867e";
          sha256 = "155khx6zvhlilpzkd3pxlqki7bgjfx475mf33zran7h000jwxsa3";
        };
      });
  # my-nvim-treesitter = pkgs.tree-sitter.withPlugins
  my-nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins
    (p: (builtins.attrValues p) ++ [ tree-sitter-astro ]);
in pkgs.neovim.override {
  vimAlias = true;
  configure = {
    packages.myplugins = with pkgs.vimPlugins; {
      start = [
        zig-vim
        vim-nix
        vim-graphql
        vim-svelte
        vim-astro
        ultisnips
        vim-snippets
        vim-fugitive
        nvim-autopairs
        # surround-nvim
        vim-commentary
        deoplete-nvim
        deoplete-lsp
        trouble-nvim
        nvim-lspconfig
        catppuccin-nvim
        my-nvim-treesitter
      ];
    };
    customRC = builtins.readFile (./vimrc);
  };
}
