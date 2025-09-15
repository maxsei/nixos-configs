# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Imports
  # imports i.e. nixos module injection (things that modify system
  # configuration). Think of this is as copying contents of the imported file
  # directly.
  imports = [
    ./hardware-configuration.nix
    ../../modules/shell
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable libvirtd
  boot.kernelModules = [ "kvm-intel" ];
  virtualisation.libvirtd.enable = true;

  # Backlight
  boot.kernelParams = ["acpi_backlight=video"];
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  # Timezone and Locale
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ pkgs.nerd-fonts.inconsolata ];
    fontconfig.defaultFonts.monospace = [ "Inconsolata" ];
    fontconfig.defaultFonts.sansSerif = [ "Fixedsys" ];
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.disabledPlugins = [ "sap" ];

  # Security
  security.pam.enableEcryptfs = true;
  security.auditd.enable = true;
  security.audit.rules = [ ]; # "-a exit,always -F arch=b64 -S execve"
  security.sudo.wheelNeedsPassword = false;

  # Users.
  users.mutableUsers = false;
  users.users.root = {
    hashedPassword = "$6$RYD2XRgkrFn$0R7E.4hDCL6kCFtiijjV1A3BZC4o8Nx7s/uvit5jz0nDu015KEhJuAWH5VKVc82dFJDycf5DjdecBcthaPns3/";
  };
  users.users.mschulte = {
    isNormalUser = true;
    home = "/home/mschulte";
    extraGroups = [
      "wheel"
      "sudo"
      "docker"
      "networkmanager"
      "adbusers"
    ];
    hashedPassword = "$6$RYD2XRgkrFn$0R7E.4hDCL6kCFtiijjV1A3BZC4o8Nx7s/uvit5jz0nDu015KEhJuAWH5VKVc82dFJDycf5DjdecBcthaPns3/";
    packages = with pkgs; [ ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    python
    python311
    go
    (callPackage ../../pkgs/neovim { inherit pkgs; })
    lf
    git
    docker
    docker-compose
    ecryptfs
    librewolf
    xclip
    gcc
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
    feh
    dasel
    android-udev-rules
    vlc
    ngrok
    python311Packages.qrcode # qr
    qrcp
    unzip
    zip
    (callPackage ../../pkgs/signal-desktop { })
    scc
    ffmpeg
    gnumake
    meld
    nixfmt-rfc-style
    patchelf
    pkg-config
    clang
    clang-tools
    zathura
    zig
    zls
    nodePackages.svelte-language-server
    (callPackage ../../pkgs/alacritty { })
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
    man-pages
    gparted
    yarn
    obs-studio
    qt5.qtwayland # XXX: need to test to see if we need this for obs
    duckdb
    binwalk
    binocle
    gnome-network-displays
    google-chrome
    git-lfs
    nodePackages.typescript-language-server
    rust-analyzer
    (pkgs.rust-bin.stable."1.78.0".default.override {
      extensions = [ "rust-src" ];
      targets = [ "wasm32-wasip1" ];
    })
    aider-chat
    wasmtime
    (pkgs.callPackage ../../pkgs/slippi-launcher { })
  ];

  # Environment variables
  environment = {
    variables = {
      EDITOR = "nvim";
    };
    sessionVariables = rec {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
      PATH = [ "\${XDG_BIN_HOME}" ];
    };
  };

  # Programs (https://nixos.wiki/wiki/NixOS_modules)
  programs.mtr.enable = true;
  programs.dconf.enable = true;
  programs.adb.enable = true;

  # Services (https://nixos.wiki/wiki/NixOS_modules)
  # XServer configuation.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  # wtf why is this shit software even on my system it leaks memory like a mf
  services.packagekit.enable = true;
  services.xserver.dpi = 96;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "caps:escape";
  # Touchpad
  services.libinput.enable = true;
  services.libinput.touchpad.tapping = true;
  services.libinput.touchpad.naturalScrolling = false;
  services.libinput.mouse.naturalScrolling = false;
  services.flatpak.enable = true;
  services.unclutter.enable = true;
  # OpenSSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.udev.extraRules = ''
    # Allows members of the wireshark group to access the usbmon device
    SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
  '';
  services.dbus.packages = with pkgs; [ gnome2.GConf ];
  # Networking
  # Hostname
  networking.hostName = "thinkpad-t440p";
  # DHCP
  networking.useDHCP = false; # global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  # Firewall
  networking.firewall.enable = false;
  networking.firewall.checkReversePath = false;
  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [ 64172 ];
  #   allowedUDPPorts = [ 67 69 4011 ];
  # };
  # Nameservers
  networking.nameservers = [ "8.8.8.8" ];
  # networking.macvlans = {
  #   wan = {
  #     interface = "wlp3s0";
  #     mode = "passthru";
  #   };
  # };
  # Pipewire
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.jack.enable = true;
  services.pulseaudio.enable = false;
  # Graphics
  hardware.graphics.enable = true;
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (lib.mkDefault "va_gl");
  };
  hardware.graphics.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
  ];
  # Syncthing
  # TODO: declarative configuration https://nixos.wiki/wiki/Syncthing
  services.syncthing.enable = true;
  services.syncthing.user = "mschulte";
  services.syncthing.configDir = "/home/mschulte/.config/syncthing"; # Folder for Syncthing's settings and keys
  # MTP
  services.gvfs.enable = true;

  services.logind.settings.Login.HandleLidSwitchDocked = "suspend";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "lock";
  # XXX: This is a crazy hack to prevent gnome from controlling power.
  systemd.services.disable-gsd-power-for-lid = {
    description = "Disable systemd inhibition for gsd power for lid";
    after = [ "graphical-session.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = let script = "";
    in {
      Type = "oneshot";
      User = "mschulte";
      ExecStart = "${pkgs.writeScript "disable-lid-switch" ''
        #!${pkgs.bash}/bin/bash

        set -eo pipefail

        # Kill existing lid-switch inhibitions
        ${pkgs.systemd}/bin/systemd-inhibit --list \
          | ${pkgs.gawk}/bin/awk '{ if (($6 == "handle-lid-switch") && ($5 == ".gsd-power-wrap")) { print $4 } }' \
          | ${pkgs.findutils}/bin/xargs -r ${pkgs.util-linux}/bin/kill

      ''}";
        # # Disable the inhibition for GNOME's power handling for lid
        # ${pkgs.systemd}/bin/systemd-inhibit \
        #   --what=sleep \
        #   --why='GNOME needs to lock the screen' \
        #   --mode=delay ${pkgs.gnome-settings-daemon}/libexec/gsd-power
      RemainAfterExit = true;
    };
  };

  # Virtualisation
  virtualisation.docker.enable = true;

  # Enable use of "nix-command"s.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Nixos 22.05
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-22.05";

  # Since Nixos 24.05 we will allow nix-ld
  programs.nix-ld.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
