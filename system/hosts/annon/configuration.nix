{ ... }:
{
  imports = [
    ./headscale.nix
    ./pi-hole.nix
    ./tailscale.nix
    ./logging.nix
    ./dashboard.nix
  ];

  system.stateVersion = "26.05";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "America/Chicago";

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ./secrets.yaml;

  networking.hostName = "annon";
  networking.useDHCP = false;
  networking.firewall.enable = true;
  networking.defaultGateway = "192.168.1.254";
  networking.nameservers = [ "127.0.0.1" ];
  networking.interfaces.end0.ipv4.addresses = [
    {
      address = "192.168.1.63";
      prefixLength = 24;
    }
  ];

  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;
  services.openssh.settings.PermitRootLogin = "yes";
  users.mutableUsers = false;

  users.users.root = {
    hashedPassword = "$y$j9T$rXYFc.bCgAjzBXSiZ8O0o.$sZYeZp3SRWvT4OejWNJeZA5ok7xUE3F6HAGQp0B5lDD";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4cZZny+4K2XmleF+r/fGh14jqnw0XHrF4a0RxFKFVc mschulte@thinkpad-t440p"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHtQ5Ipk7VmzOVMTXMLIjayulEUTJLNLemj62XR6ZFV mschulte@pixel8"
    ];
  };
}
