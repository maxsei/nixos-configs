# ...
{ neovim, vimPlugins, ripgrep, vimUtils, lib, callPackage, fetchFromGitHub, ...
}:
# TODO: make this a nixos module instead of a package <02-10-24, Max Schulte> #
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
        telescope-nvim
        # surround-nvim
        vim-commentary
        deoplete-nvim
        deoplete-lsp
        trouble-nvim
        nvim-lspconfig
        catppuccin-nvim
        plenary-nvim
        nvim-treesitter
        ChatGPT-nvim
      ];
    };
    customRC = builtins.readFile (./vimrc);
  };
}
