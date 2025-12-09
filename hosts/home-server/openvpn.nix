{
  config,
  lib,
  pkgs,
  ...
}:

let
  vpnSubnet = "10.8.0.0";
  vpnMask = "255.255.255.0";
  vpnDevice = "tun0";
  vpnPort = 1194;
in

{
  networking.nat = {
    enable = true;
    externalInterface = "wlp0s29u1u3";
    internalInterfaces = [ vpnDevice ];
  };
  networking.firewall.allowedUDPPorts = [
    vpnPort
    53
  ];
  networking.firewall.trustedInterfaces = [ vpnDevice ];

  sops.secrets."openvpn/servers/server/secret" = { };

  services.openvpn.servers.server = {
    config = ''
      dev ${vpnDevice}
      proto udp
      ifconfig 10.8.0.1 10.8.0.2
      secret ${config.sops.secrets."openvpn/servers/server/secret".path}
      port ${toString vpnPort}

      cipher AES-256-CBC
      auth-nocache

      comp-lzo
      keepalive 10 60
      ping-timer-rem
      persist-tun

      # Push VPN host DNS to clients.
      push "dhcp-option DNS 10.8.0.1"
    '';
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "generate-openvpn-client" ''
      set -ue -o pipefail

      cat << EOF
      dev tun
      remote maxsei.chickenkiller.com
      ifconfig 10.8.0.2 10.8.0.1
      port ${toString vpnPort}
      redirect-gateway def1

      cipher AES-256-CBC
      auth-nocache

      comp-lzo
      keepalive 10 60
      resolv-retry infinite
      nobind
      persist-key
      persist-tun
      secret [inline]

      <secret>
      EOF

      cat ${config.sops.secrets."openvpn/servers/server/secret".path}

      cat << EOF
      </secret>
      EOF
    '')
  ];


  services.dnsmasq = {
    enable = true;
    settings = {
      interface = vpnDevice;
      address = "/home.local/10.8.0.1";
      log-queries = "yes";
    };
  };
}
