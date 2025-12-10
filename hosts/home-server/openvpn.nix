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
  vpnName = "server";
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

  services.openvpn.servers.${vpnName} = {
    config = ''
      port ${toString vpnPort}
      proto udp
      dev ${vpnDevice}

      tls-server

      ecdh-curve ed25519
      dh none

      ca /etc/openvpn/server/ca.crt
      cert /etc/openvpn/server/server.crt
      key /etc/openvpn/server/server.key
      tls-crypt /etc/openvpn/server/ta.key

      user nobody
      group nogroup

      persist-key
      persist-tun
      keepalive 10 60

      cipher AES-256-GCM
      ncp-ciphers AES-256-GCM
      auth SHA512

      allow-compression no

      server ${vpnSubnet} ${vpnMask}
      push "dhcp-option DNS 10.8.0.1"
    '';
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "generate-openvpn-client" ''
        set -euo pipefail

        CLIENT_NAME=client
        EASYRSA_DIR="/etc/openvpn/easy-rsa"
        PKI_DIR="/etc/openvpn/pki"
        VPN_PORT=${toString vpnPort}
        VPN_SERVER="maxsei.chickenkiller.com"
        TMPFILE="$(mktemp)"
        trap 'rm -rf -- "$TMPFILE"' EXIT

        export EASYRSA_VARS_FILE="$EASYRSA_DIR/vars"

        cd "/etc/openvpn"

        ${pkgs.easyrsa}/bin/easyrsa --batch gen-req "$CLIENT_NAME" nopass 1>&2
        ${pkgs.easyrsa}/bin/easyrsa --batch sign-req client "$CLIENT_NAME" 1>&2

        cat > "$TMPFILE" <<EOF
      client
      dev tun
      proto udp
      remote $VPN_SERVER $VPN_PORT
      resolv-retry infinite
      nobind
      persist-key
      persist-tun
      cipher AES-256-GCM
      auth SHA512

      <ca>
      EOF

        cat "$PKI_DIR/ca.crt" >> "$TMPFILE"
        echo "</ca>" >> "$TMPFILE"

        echo "<cert>" >> "$TMPFILE"
        cat "$PKI_DIR/issued/$CLIENT_NAME.crt" >> "$TMPFILE"
        echo "</cert>" >> "$TMPFILE"

        echo "<key>" >> "$TMPFILE"
        cat "$PKI_DIR/private/$CLIENT_NAME.key" >> "$TMPFILE"
        echo "</key>" >> "$TMPFILE"

        echo "<tls-crypt>" >> "$TMPFILE"
        cat /etc/openvpn/server/ta.key >> "$TMPFILE"
        echo "</tls-crypt>" >> "$TMPFILE"

        cat "$TMPFILE"
    '')
  ];

  systemd.tmpfiles.rules = [
    "d /etc/openvpn 0750 root root - -"
  ];

  environment.etc."openvpn/easy-rsa/vars" = {
    text = ''
      set_var EASYRSA_DIGEST "sha512"
      set_var EASYRSA_ALGO  ed
      set_var EASYRSA_CURVE ed25519
    '';
    mode = "0644";
  };

  system.activationScripts.openvpn-pki =
    let
      script = pkgs.writeShellApplication {
        name = "openvpn-pki";
        runtimeInputs = with pkgs; [
          gawk
          gnused
          easyrsa
          coreutils
          openvpn
        ];
        text = ''
          set -euo pipefail

          PKI_DIR="/etc/openvpn/pki"
          SERVER_DIR="/etc/openvpn/server"
          export EASYRSA_VARS_FILE=/etc/openvpn/easy-rsa/vars

          if [ ! -d "$PKI_DIR" ]; then
            TMPDIR=$(mktemp -d)
            trap 'rm -rf "$TMPDIR"' EXIT
            cd "$TMPDIR"

            easyrsa init-pki
            echo -ne '\n' | easyrsa build-ca nopass
            easyrsa --batch gen-req server nopass
            easyrsa --batch sign-req server server

            openvpn --genkey tls-crypt "$TMPDIR/server-ta.key"

            mkdir -p "$PKI_DIR" "$SERVER_DIR"

            cp -a ./pki/. "$PKI_DIR/"

            install -m 0600 "$TMPDIR/server-ta.key" "$SERVER_DIR/ta.key"
            ln -sf "$PKI_DIR/ca.crt"              "$SERVER_DIR/ca.crt"
            ln -sf "$PKI_DIR/issued/server.crt"   "$SERVER_DIR/server.crt"
            ln -sf "$PKI_DIR/private/server.key"  "$SERVER_DIR/server.key"
          fi
        '';
      };
    in
    "${script}/bin/openvpn-pki || true";

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = vpnDevice;
      address = "/home.local/10.8.0.1";
      log-queries = "yes";
    };
  };
}
