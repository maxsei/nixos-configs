# ...
{ neovim, vimPlugins, ripgrep, vimUtils, lib, callPackage, fetchFromGitHub, ...
}:
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
  catppuccin-nvim = vimUtils.buildVimPlugin {
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
  vim-astro = vimUtils.buildVimPlugin {
    pname = "vim-astro";
    version = "2022-08-24";
    src = fetchFromGitHub {
      owner = "wuelnerdotexe";
      repo = "vim-astro";
      rev = "34732be5e9a5c28c2409f4490edf92d46d8b55a9";
      sha256 = "1ild33hxiphj0z8b4kpcad4rai7q7jd0lsmhpa30kfgmyj5kh90z";
    };
  };
  nvim-telescope = vimUtils.buildVimPlugin {
    pname = "nvim-telescope";
    version = "0.1.2";
    src = fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "776b509f80dd49d8205b9b0d94485568236d1192";
      sha256 = "sha256-fV3LLRwAPykVGc4ImOnUSP+WTrPp9Ad9OTfBJ6wqTMk=";
    };
    nativeBuildInputs = [ ripgrep ];
  };
in neovim.override {
  vimAlias = true;
  configure = {
    packages.myplugins = with vimPlugins; {
      start = [
        zig-vim
        vim-terraform
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
        plenary-nvim
        nvim-telescope
        nvim-treesitter
        ChatGPT-nvim
      ];
    };
    customRC = builtins.readFile (./vimrc);
  };
}
