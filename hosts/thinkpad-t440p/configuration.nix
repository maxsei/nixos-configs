# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  # Imports
  # imports i.e. nixos module injection (things that modify system
  # configuration). Think of this is as copying contents of the imported file
  # directly.
  imports = [
    ./hardware-configuration.nix
    ../../common/yubikey.nix
    ../../common/nixops
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Timezone and Locale
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Security
  security.pam.enableEcryptfs = true;
  security.auditd.enable = true;
  security.audit.rules = []; # "-a exit,always -F arch=b64 -S execve"
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
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIRtjqZtIJr1Ss6f5dSlRsv2p9G2nI9U8lLZDOUhSy40 maximilliangschulte@pm.me" ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    python
    go
    (import ../../pkgs/neovim {inherit pkgs;})
    lf
    git
    docker
    ecryptfs
    ecryptfs-helper
    # firefox
    firefox-wayland
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
    python39Packages.qrcode # qr
    qrcp
    unzip
    nixops
  ];
  # Unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem ((import <nixpkgs> {}).lib.getName pkg) [
    "obsidian"
    "slack"
    "ngrok"
  ];

  # Environment variables
  environment = {
    variables = {
      EDITOR = "nvim";
    };
    sessionVariables = rec {
      XDG_CACHE_HOME  = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME    = "\${HOME}/.local/bin";
      XDG_DATA_HOME   = "\${HOME}/.local/share";
      PATH = [
        "\${XDG_BIN_HOME}"
      ];
    };
  };

  # Programs (https://nixos.wiki/wiki/NixOS_modules)
  programs.mtr.enable = true;
  programs.dconf.enable = true;
  programs.bash.promptInit = builtins.readFile (./prompt.bash);
  programs.adb.enable = true;


  # Services (https://nixos.wiki/wiki/NixOS_modules)
  # XServer configuation.
  services.xserver.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.dpi = 96;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:escape";
  # Touchpad
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.tapping = true;
  services.xserver.libinput.touchpad.naturalScrolling = false;
  services.xserver.libinput.mouse.naturalScrolling = false;
  services.flatpak.enable = true;
  # OpenSSH
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;
  services.openssh.passwordAuthentication = false;
  # Gnome auxilary services
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
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
  # Pipewire
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.jack.enable = true;
  hardware.pulseaudio.enable = false;
  sound.enable = true;
  # Syncthing
  # TODO: declarative configuration https://nixos.wiki/wiki/Syncthing
  services.syncthing.enable = true;
  services.syncthing.user = "mschulte";
  services.syncthing.configDir = "/home/mschulte/.config/syncthing";   # Folder for Syncthing's settings and keys
  # MTP
  services.gvfs.enable = true;


  # Virtualisation
  virtualisation.docker.enable = true;

  # Enable use of "nix-command"s.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Nixos 22.05
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-22.05";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
