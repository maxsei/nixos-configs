{ config, pkgs, ... }:
{
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallDHCP = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "StevenBlack unified hosts";
      }
    ];
    settings = {
      dns = {
        listeningMode = "ALL";
        blocking.mode = "NX";
        hosts = [ "${(builtins.head config.networking.interfaces.end0.ipv4.addresses).address} maxsei.chickenkiller.com" ];
        upstreams = [
          # OpenDNS
          "208.67.222.222"
          "208.67.220.220"
        ];
      };
      misc.privacylevel = 3; # anonymous mode
      dhcp = {
        active = true;
        start = "192.168.1.64";
        end = "192.168.1.253";
        router = config.networking.defaultGateway.address;
      };
    };
  };

  services.pihole-web = {
    enable = true;
    ports = [ 8001 ];
  };
  networking.firewall.allowedTCPPorts = [ 8001 ];

  sops.secrets."att-password" = { };
  systemd.services.att-disable-dhcp-and-ipv6 = {
    description = "disable the AT&T modem's own DHCP server and LAN IPv6 so pi-hole is the only DHCP/DNS path on the LAN";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      Environment = [
        "ATT_PASSWORD_FILE=${config.sops.secrets."att-password".path}"
        "ATT_GATEWAY_IP=${config.networking.defaultGateway.address}"
      ];
      ExecStart = "${
        pkgs.python3.withPackages (ps: [ ps.requests ])
      }/bin/python3 ${./att-scripts}/att-disable-dhcp-and-ipv6.py";
    };
  };
}
