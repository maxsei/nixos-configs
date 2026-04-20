{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ tailscale ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  services.resolved = {
    enable = true;
    dnssec = "false";        # or "allow-downgrade"
    fallbackDns = [ "8.8.8.8" "1.1.1.1" ];
  };

  networking.nameservers = [ "127.0.0.53" ];
}
