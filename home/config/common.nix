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

  home.packages = with pkgs; [
    dig
    wget
    curl
    python3
    go
    (pkgs.callPackage ./neovim {
      system = pkgs.system;
      nixvim = inputs.nixvim;
    })
    lf
    git
    docker
    docker-compose
    wl-clipboard
    gimp
    fastfetch
    lsof
    strace
    obsidian
    slack
    ripgrep
    tealdeer
    feh
    dasel
    vlc
    ngrok
    python311Packages.qrcode
    qrcp
    unzip
    zip
    (pkgs.callPackage ../../pkgs/signal-desktop { })
    scc
    ffmpeg
    gnumake
    meld
    nixfmt
    patchelf
    pkg-config
    clang
    clang-tools
    zathura
    zig
    zls
    svelte-language-server
    nodejs
    wireshark
    nmap
    filezilla
    android-tools
    scrcpy
    gotools
    gopls
    file
    golangci-lint
    dbeaver-bin
    pup
    yarn
    obs-studio
    qt5.qtwayland
    duckdb
    binwalk
    binocle
    gnome-network-displays
    git-lfs
    typescript-language-server
    aider-chat
    wasmtime
    (pkgs.callPackage ../../pkgs/slippi-launcher { })
    bun
    imagemagick
    arp-scan
    litecli
    claude-code
    entr
    jq
    yq-go
    minicom
    pstree
    tree
    usbutils
    htop
    sops
    pwgen
    gitleaks
    pre-commit
  ];

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

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    enable-hot-corners = false;
    show-battery-percentage = true;
    toolkit-accessibility = false;
  };

  dconf.settings."org/gnome/desktop/input-sources" = {
    xkb-options = [ "caps:escape" ];
  };

  dconf.settings."org/gnome/desktop/peripherals/touchpad" = {
    natural-scroll = false;
  };

  dconf.settings."org/gnome/desktop/peripherals/mouse" = {
    natural-scroll = false;
  };

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
