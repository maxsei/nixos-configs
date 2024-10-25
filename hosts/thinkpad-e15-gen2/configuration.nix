# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common/yubikey.nix
      # ../../common/neovim
      # ../../common/wayland.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad-e15-gen2"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # neovim nightly.
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      # url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/2abb3014b87c0b63bb30be4e199c7bf280d05807.tar.gz;
    }))
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    python
    python36
    python36Packages.pip
    python37
    python37Packages.pip
    python38
    python38Packages.pip
    python38Packages.pipx
    go
    neovim-nightly
    lf
    git
    docker
    docker-compose
    buildkit
    ecryptfs
    ecryptfs-helper
    firefox
    xclip
    syncthing
    gcc
    gnumake
    gdb
    xclip
    gimp
    pciutils
    lshw
    libreoffice
    neofetch
    lsof
    strace
    obsidian
    slack
    ripgrep
    tealdeer
    nodejs
    cloc
    feh
    fzf
    obs-studio
    bench
    cloc
    ffmpeg
    flameshot
    gdb
    git-lfs
    htop
    jq
    meld
    # openblas
    python-language-server
    # lapack
    # zlib
    youtube-dl
    geckodriver
    glib
    ngrok
    pkg-config
    zip
  ];

  # Node packages.
  # environment.systemPackages.nodePackages = with nodePackages; [
  #    "svelte-language-server"
  # ];

  # # Flakes:
  # nix = {
  #   package = pkgs.nixFlakes;
  #   extraOptions = ''
  #     experimental-features = nix-command flakes
  #   '';
  # };

  # Unfree packages
  # nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name) [
  #   "obsidian"
  #   "slack"
  # ]);
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem ((import <nixpkgs> {}).lib.getName pkg) [
    "obsidian"
    "slack"
    "vscode"
    "telegram-desktop"
    "ngrok"
  ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select enternationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    # Compatibility shims, adjust according to your needs
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # bluetooth
  hardware.bluetooth.enable = true;

  # XServer configuation.
  services.xserver = {
    # Basic
    dpi = 96;
    layout = "us";
    enable = true;

    # Video drivers
    videoDrivers = [ "intel" ];

    # Window managers
    windowManager.bspwm.enable = true;

    # Gnome -Wayland
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;
    desktopManager.gnome.enable = true;

    # Keymappings in Xserver.
    xkbOptions = "caps:escape";

    # Configure the touchpad
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = false;
      };
      mouse.naturalScrolling = false;
    };
  };

  # Create mschulte user.
  users.users.mschulte = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sudo" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Environment variables.
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  environment.shellAliases = {
    "vim" = "nvim";
    "tldr" = "tealdeer";
  };

  # Security
  security.pam.enableEcryptfs = true;
  security.auditd.enable = true;
  security.audit = {
    enable = true;
    rules = [
      # "-a exit,always -F arch=b64 -S execve"
    ];
  };
  security.sudo.wheelNeedsPassword = false;

  # List other services that you want to enable:
  programs.mtr.enable = true;
  virtualisation.docker.enable = true;
  services.flatpak.enable = true;
  # Gnome auxilary services.
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ gnome2.GConf ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;

  # Firewall options.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.checkReversePath = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
