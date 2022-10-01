pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = builtins.readFile (./vimrc);
      packages.myplugins = with pkgs.vimPlugins; {
        start = [
	  catppuccin-nvim
          vim-nix
        ];
      };
    };
  }
