{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nixpkgs.config = {
    permittedInsecurePackages = [
      "python-2.7.18.12"
      "electron-24.8.6"
    ];
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "obsidian"
        "slack"
        "ngrok"
        "claude-code"
      ];
  };

  imports = [
    ../modules/sccache
  ]
  ++ [
    ./alacritty
    ./rust-toolchain
    ./shell/bash
  ];

  programs.tmux = {
    enable = true;
    shell = "${pkgs.bash}/bin/bash";
    terminal = "tmux-256color";
    mouse = true;
    extraConfig = ''
      set -as terminal-features ",*:RGB"

      set -g base-index 1
      setw -g pane-base-index 1
    '';
  };

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      { id = "epcnnfbjfcgphgdmggkamkmgojdagdnn"; } # ublock origin
      { id = "khncfooichmfjbepaaaebmommgaepoid"; } # unhook
      { id = "ocaahdebbfolfmndjeplogmgcagdmblk"; } # chromium web store
    ];
  };

  home.stateVersion = "21.05";

  home.packages =
    with pkgs;
    (
      [
        (pkgs.callPackage ./neovim {
          system = pkgs.system;
          nixvim = inputs.nixvim;
        })
        (pkgs.callPackage ../../pkgs/signal-desktop { })
        (pkgs.callPackage ../../pkgs/slippi-launcher { })
      ]
      ++ [
        age
        android-tools
        arp-scan
        binocle
        binwalk
        bun
        clang
        clang-tools
        claude-code
        curl
        dasel
        dbeaver-bin
        dig
        docker
        docker-compose
        duckdb
        entr
        fastfetch
        feh
        ffmpeg
        file
        filezilla
        gimp
        git
        gitleaks
        git-lfs
        gnome-network-displays
        gnumake
        go
        golangci-lint
        gopls
        gotools
        htop
        imagemagick
        jq
        lf
        litecli
        lsof
        meld
        minicom
        ngrok
        nixfmt
        nmap
        nodejs
        obsidian
        obs-studio
        patchelf
        pkg-config
        pre-commit
        pstree
        pup
        pwgen
        python3
        python311Packages.qrcode
        qrcp
        qt5.qtwayland
        ripgrep
        scc
        scrcpy
        slack
        sops
        strace
        svelte-language-server
        tealdeer
        tree
        typescript-language-server
        unzip
        usbutils
        uv
        vlc
        wasmtime
        wget
        wireshark
        wl-clipboard
        yarn
        yq-go
        zathura
        zig
        zip
        zls
      ]
    );

  home.sessionVariables = {
    EDITOR = "nvim";
    HISTSIZE = "";
    HISTFILESIZE = "";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_BIN_HOME = "${config.home.homeDirectory}/.local/bin";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  services.syncthing.enable = true;

  programs.home-manager.enable = true;

  gtk.enable = true;
  gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  gtk.gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  gtk.gtk4.theme = null;

  dconf = lib.mkIf pkgs.stdenv.isLinux {
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        show-battery-percentage = true;
        toolkit-accessibility = false;
      };

      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "caps:escape" ];
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = false;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = false;
      };
    };
  };

  home.file.".cargo/config.toml".text = ''
    [env]
    DUCKDB_DOWNLOAD_LIB = "1"
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      url."git@github.com:".insteadOf = "https://github.com/";
      push.autoSetupRemote = true;
      merge.tool = "vimdiff";
    };
  };
}
