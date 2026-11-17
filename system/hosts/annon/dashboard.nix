{ pkgs, ... }:
let
  tsHost = "annon.ts.maxsei.chickenkiller.com";
  tsCertDir = "/var/lib/annon-ts-cert";
in
{
  # Self-signed: tailscale's tunnel already encrypts this traffic, the cert
  # just lets browsers use https:// without hitting the public headscale vhost.
  systemd.services.annon-ts-cert = {
    description = "Generate annon's self-signed cert for ${tsHost} (once)";
    wantedBy = [ "multi-user.target" ];
    before = [ "nginx.service" ];
    path = [ pkgs.openssl ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0022";
    };
    script = ''
      if [ -f "${tsCertDir}/cert.pem" ] && [ -f "${tsCertDir}/key.pem" ]; then
        exit 0
      fi
      mkdir -p "${tsCertDir}"
      openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
        -keyout "${tsCertDir}/key.pem" -out "${tsCertDir}/cert.pem" \
        -subj "/CN=${tsHost}" -addext "subjectAltName=DNS:${tsHost}"
      chmod 0755 "${tsCertDir}"
      chmod 0644 "${tsCertDir}/cert.pem" "${tsCertDir}/key.pem"
    '';
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = 8083;
    allowedHosts = "${tsHost},localhost:8083,127.0.0.1:8083";
    services = [
      {
        "annon" = [
          {
            "Grafana" = {
              href = "https://${tsHost}/grafana/";
              description = "Centralized logs across annon's services";
            };
          }
          {
            "Pi-hole" = {
              href = "https://${tsHost}/pihole/";
              description = "DNS/DHCP admin";
            };
          }
          {
            "Headscale" = {
              href = "https://maxsei.chickenkiller.com";
              description = "Tailnet coordination server";
            };
          }
        ];
      }
    ];
  };

  services.nginx.virtualHosts."annon-ts" = {
    serverName = tsHost;
    forceSSL = true;
    sslCertificate = "${tsCertDir}/cert.pem";
    sslCertificateKey = "${tsCertDir}/key.pem";
    listen = [
      {
        addr = "100.64.0.1";
        port = 80;
      }
      {
        addr = "100.64.0.1";
        port = 443;
        ssl = true;
      }
    ];
    locations."/" = {
      proxyPass = "http://127.0.0.1:8083";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
      '';
    };
    locations."/grafana/" = {
      proxyPass = "http://127.0.0.1:3000/grafana/";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
      '';
    };
    locations."/pihole/" = {
      proxyPass = "http://127.0.0.1:8001/";
      extraConfig = ''
        proxy_set_header Host $host;
      '';
    };
  };
}
