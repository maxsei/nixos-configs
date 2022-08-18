#
{ config, pkgs, ... }:

{
  # Be careful updating this.
  # boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # We expect to run the VM on hidpi machines.
  hardware.video.hidpi.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "rasp-plex";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Plex.
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # Disable display manager.
  # services = {
  #   xserver = {
  services.xserver = {
        displayManager = {
          defaultSession = "none";
          # autoLogin = {
          #   enable = true;
          #   user = user;
          # };
        };
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.mutableUsers = false;
  # Root password is test.
  users.users.root.password = "test";
  users.users.test = {
    password = "test";
    groups = [ "wheel" ];
  };
  # users.extraUsers.test.hashedPassword = "$6$sAaP0zlwJm6$47UJFmismUQFHq4OVJ8e4Pcpk.RxBQgYR1nSOLd3vsCEIR2bczJiDjkXoTVjQkUd713PZeWwF94btnu6N6rsO0";
  # users.extraUsers.test.hashedPassword = "$6$sAaP0zlwJm6$47UJFmismUQFHq4OVJ8e4Pcpk.RxBQgYR1nSOLd3vsCEIR2bczJiDjkXoTVjQkUd713PZeWwF94btnu6N6rsO0";

  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
