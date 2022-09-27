# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common/yubikey.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad-t440p"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    python
    go
    neovim
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
    obs-studio
  ];

  # Unfree packages
  # nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name) [ 
  #   "obsidian"
  #   "slack"
  # ]);
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem ((import <nixpkgs> {}).lib.getName pkg) [
    "obsidian"
    "slack"
  ];


  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

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
    enable = true;
    # Window managers.
    windowManager = {
      bspwm.enable = true;
    };
    # Display managers.
    displayManager = {
      gdm.enable = true;
    };
    # Desktop managers.
    desktopManager = {
      gnome.enable = true;
    };
    dpi = 96;
    layout = "us";
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
   xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
  };

  # Immutable users
  users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root.hashedPassword = "$6$RYD2XRgkrFn$0R7E.4hDCL6kCFtiijjV1A3BZC4o8Nx7s/uvit5jz0nDu015KEhJuAWH5VKVc82dFJDycf5DjdecBcthaPns3/";
  users.users.mschulte = {
    isNormalUser = true;
    home = "/home/mschulte";
    extraGroups = [ "wheel" "sudo" "docker" "networkmanager" ];
    hashedPassword = "$6$RYD2XRgkrFn$0R7E.4hDCL6kCFtiijjV1A3BZC4o8Nx7s/uvit5jz0nDu015KEhJuAWH5VKVc82dFJDycf5DjdecBcthaPns3/";
    packages = with pkgs; [
    ];
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
  };

  # Neovim
  # runtime.<name>.target
  # runtime.<name>.source
  # runtime.<name>.enable
  # runtime.<name>.text  
  programs.neovim = {
    defaultEditor = true;
    # configure
    # withRuby
    vimAlias = true;
    # runtime
    # package
    # viAlias
    # enable
  };

  environment.shellAliases = {
    "vim" = "nvim";
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

  # Shell config
  programs.bash.promptInit = builtins.readFile (./prompt.bash);

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;

  # Enable syncthing.
  # TODO: declarative configuration https://nixos.wiki/wiki/Syncthing
  services = {
    syncthing = {
      enable = true;
      user = "mschulte";
      configDir = "/home/mschulte/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };

  # Firewall options.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.checkReversePath = false;

  # Run a dns server to route local domains
  services.coredns.enable = true;
  services.coredns.config =
    ''
      . {
        # Forward all dns requests to Cloudflare and Google.
        forward . 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
        cache
      }
  
      # ...Except any requests with a .local domain
      local {
	# Replace .local domain with 127.0.0.1
        template IN A  {
          answer "{{ .Name }} 0 IN A 127.0.0.1"
        }
      }
    '';



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
