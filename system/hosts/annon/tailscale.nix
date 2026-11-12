{ pkgs, config, ... }:
{
  systemd.services.headscale-bootstrap = {
    description = "Ensure headscale admin user and self preauth key";
    after = [
      "headscale.service"
      "tailscaled.service"
    ];
    requires = [
      "headscale.service"
      "tailscaled.service"
    ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      config.services.headscale.package
      tailscale
      jq
      coreutils
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0077";
    };
    script = ''
      for i in $(seq 1 8); do
        headscale users list -o json >/dev/null 2>&1 && break
        timeout="$((2 ** $i))"
        printf "waiting %ss for headscale\n..." "$timeout"
        sleep "$timeout"
      done

      id=$(headscale users list -o json | jq -r '(. // [])[] | select(.name=="admin") | .id')
      if [ -z "$id" ]; then
        headscale users create admin
        id=$(headscale users list -o json | jq -r '(. // [])[] | select(.name=="admin") | .id')
      fi

      key=$(headscale preauthkeys create --user "$id" --expiration 5m -o json | jq -r '.key')
      state=$(tailscale status --json --peers=false | jq -r '.BackendState')
      case "$state" in
        NeedsLogin|NeedsMachineAuth|Stopped)
          tailscale up \
            --login-server=https://127.0.0.1:443 \
            --auth-key="$key" \
            --hostname=annon \
            --accept-routes \
            --timeout 60s
          ;;
        *) echo "tailscale state is $state, nothing to do" ;;
      esac
    '';
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--accept-dns=false" ];
  };
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
