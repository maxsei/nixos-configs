{ inputs, config, ... }:
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  sops.secrets."hermes-env" = { };

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend.mode = "dashboard";
    backend.port = 9119;
    settings.model.default = "anthropic/claude-sonnet-4-5";
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
  };

  # sops-nix writes secrets via a oneshot systemd service. Order hermes-agent
  # after it so on startup the secret is already in place. Also re-merge
  # ~/.hermes/.env from the sops secret before each start, so that a
  # `home-manager switch` that only updates secrets (no activation re-run)
  # still takes effect on the next restart.
  systemd.user.services.hermes-agent = {
    Unit.After = [ "sops-nix.service" ];
    Service.ExecStartPre = [
      "/bin/sh -c 'install -m 0600 ${config.sops.secrets."hermes-env".path} ${config.home.homeDirectory}/.hermes/.env'"
    ];
  };
}
