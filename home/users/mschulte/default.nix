{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../config/shell/bash
  ];

  home.username = "mschulte";
  home.homeDirectory = "/home/mschulte";
  home.stateVersion = "21.05";

  # User packages
  home.packages = with pkgs; [
    dig
    wget
    curl
    python3
    go
    (pkgs.callPackage ../../config/neovim { system = pkgs.system; nixvim = inputs.nixvim; })
    lf
    git
    docker
    docker-compose
    xclip
    gcc
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
    (pkgs.callPackage ../../../pkgs/signal-desktop { })
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
    (pkgs.callPackage ../../config/alacritty { })
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
    ungoogled-chromium
    git-lfs
    typescript-language-server
    rust-analyzer
    (pkgs.rust-bin.stable."1.78.0".default.override {
      extensions = [ "rust-src" ];
      targets = [ "wasm32-wasip1" ];
    })
    aider-chat
    wasmtime
    (pkgs.callPackage ../../../pkgs/slippi-launcher { })
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
  ];

  # Environment variables
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

  # Syncthing
  services.syncthing.enable = true;

  programs.home-manager.enable = true;
}
