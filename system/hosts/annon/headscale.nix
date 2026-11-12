{ config, pkgs, ... }:
let
  host = "maxsei.chickenkiller.com";
  port = 8080;
  proxyPort = 443;
  acmePort = 80;
  tsBaseDomain = "ts.${host}";
in
{
  services.headscale = {
    enable = true;
    settings = {
      server_url = "https://${host}:${toString proxyPort}";
      listen_addr = "127.0.0.1:${toString port}";
      metrics_listen_addr = "127.0.0.1:9090";
      dns = {
        magic_dns = true;
        base_domain = tsBaseDomain;
        nameservers.global = [ "100.64.0.1" ] ++ config.services.pihole-ftl.settings.dns.upstreams;
      };
      derp.server.enabled = false;
    };
  };

  sops.secrets."att-password" = { };
  systemd.services.att-port-forward = {
    description = "forward the headscale port through the AT&T modem's NAT";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      Environment = [
        "ATT_PASSWORD_FILE=${config.sops.secrets."att-password".path}"
        "ATT_GATEWAY_IP=${config.networking.defaultGateway.address}"
        "HOST_IP=${(builtins.head config.networking.interfaces.end0.ipv4.addresses).address}"
      ];
      ExecStart =
        let
          attPortForward = "${
            pkgs.python3.withPackages (ps: [ ps.requests ])
          }/bin/python3 ${./att-scripts}/att-port-forward.py";
        in
        pkgs.writeShellApplication {
          name = "att-port-forward";
          text = ''
            for port in ${toString proxyPort} ${toString acmePort}; do
              ATT_GATEWAY_PORT=$port HOST_PORT=$port ${attPortForward}
            done
          '';
        }
        + "/bin/att-port-forward";
    };
  };

  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "maximilliangschulte@gmail.com";
  };
  services.nginx.virtualHosts."headscale-proxy" = {
    serverName = host;
    forceSSL = true;
    enableACME = true;
    listen = [
      {
        addr = "0.0.0.0";
        port = proxyPort;
        ssl = true;
      }
      {
        addr = "0.0.0.0";
        port = acmePort;
      }
    ];
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_buffering off;
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [
    proxyPort
    acmePort
  ];

  networking.firewall.allowPing = false;
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
  };

  sops.secrets."freedns-password" = {
    owner = config.systemd.services.inadyn.serviceConfig.User;
  };
  services.inadyn = {
    enable = true;
    settings = {
      provider."freedns.afraid.org" = {
        username = "maxsei";
        hostname = host;
        include = config.sops.secrets."freedns-password".path;
      };
    };
  };
}
