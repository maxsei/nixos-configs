{ pkgs, ... }:
{
  services.baikal.enable = true;
  services.nginx.enable = true;

  services.nginx.virtualHosts."baikal" = {
    addSSL = true;
    sslCertificate = "/var/lib/local-ssl/cert.pem";
    sslCertificateKey = "/var/lib/local-ssl/key.pem";
  };

  # Generate a self-signed cert for LAN-only HTTPS access if one doesn't
  # already exist. Shared by any other locally-proxied nginx vhost (e.g.
  # the headscale reverse proxy).
  system.activationScripts.localSelfSignedCert = ''
    mkdir -p /var/lib/local-ssl
    if [ ! -f /var/lib/local-ssl/cert.pem ]; then
      ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 3650 \
        -newkey rsa:2048 \
        -keyout /var/lib/local-ssl/key.pem \
        -out /var/lib/local-ssl/cert.pem \
        -subj "/CN=thinkpad-t440p"
      chown nginx:nginx /var/lib/local-ssl/key.pem /var/lib/local-ssl/cert.pem
      chmod 600 /var/lib/local-ssl/key.pem
    fi
  '';

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
