{ pkgs, ... }:

let
  # Define the packages you want to include
  vimPlugins = with pkgs.vimPlugins; [
    vim-nix           # For Nix syntax highlighting and support
    vim-go            # For Go development support
    coc.nvim          # For completion and language server support
    vim-prettier      # For formatting TypeScript code
  ];

  # Include gopls and typescript language server
  gopls = pkgs.goPackages.gopls;
  tsserver = pkgs.nodePackages.typescript-language-server;

in {
  # Enable Home Manager
  home.packages = [
    pkgs.vim         # Install Vim
    gopls            # Install gopls
    tsserver         # Install TypeScript language server
  ];

  # Configure Vim
  programs.vim = {
    enable = true;                   # Enable Vim
    plugins = vimPlugins;            # Load defined plugins
    extraConfig = ''
      " Set up CoC (Conquer of Completion) for language servers
      let g:coc_global_extensions = [
        \ 'coc-go',                " Go language support
        \ 'coc-tsserver',          " TypeScript support
        \ ]
      
      " Optional: Add additional settings for Vim
      set number              " Show line numbers
      syntax on              " Enable syntax highlighting
      filetype plugin indent on  " Enable filetype detection
      
      " Set up Prettier for TypeScript formatting
      autocmd FileType typescript,json setlocal formatprg=prettier\ --stdin-filepath\ %
    '';
  };

  # Enable CoC and configure Node.js (for TypeScript server)
  programs.nodejs.enable = true; # Enable Node.js for typescript-language-server
}
