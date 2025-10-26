{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    (modulesPath + "/profiles/headless.nix")
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Chicago";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  networking.firewall.enable = true;
  networking.networkmanager.enable = true;
  networking.interfaces.enp4s0.ipv4.addresses = [
    {
      address = "169.254.55.155";
      prefixLength = 16;
    }
  ];
  networking.dhcpcd.denyInterfaces = [ "enp4s0" ];
  # TODO: sops + wpa_supplicant
  # networking.wireless.networks = {
  #   "ThatAintMyBabyDaddy2" = {
  #     bssid = "";
  #     psk = "";
  #   };
  # };

  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;
  services.openssh.settings.PermitRootLogin = "yes";
  users.mutableUsers = false;

  users.users.root = {
    hashedPassword = "$y$j9T$CAsKg/2va76MOzrr1tA9j/$4Qh.N.zOhlsnTYeBysOBuwkE/ZlcfiTE9Sgkv/S/gCA";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4cZZny+4K2XmleF+r/fGh14jqnw0XHrF4a0RxFKFVc mschulte@thinkpad-t440p"
    ];
  };

  services.immich.enable = true;
  services.immich.host = "0.0.0.0";
  services.immich.openFirewall = true;
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
  services.immich.machine-learning.enable = false;

  system.stateVersion = "24.11";
}
