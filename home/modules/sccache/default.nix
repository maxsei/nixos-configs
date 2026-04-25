{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.sccache;
in
{

  options.services.sccache = {
    enable = mkEnableOption "sccache user daemon";

    cacheDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.cache/sccache";
      description = "Directory where sccache stores cached objects.";
    };

    cacheSize = mkOption {
      type = types.str;
      default = "10G";
      description = "Maximum on-disk cache size (e.g. 10G, 20G).";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sccache;
      description = "The sccache package to use.";
    };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    home.sessionVariables = {
      RUSTC_WRAPPER = "${cfg.package}/bin/sccache";
      SCCACHE_DIR = cfg.cacheDir;
      SCCACHE_CACHE_SIZE = cfg.cacheSize;
      CARGO_INCREMENTAL = "0";
    };

    systemd.user.sessionVariables = {
      RUSTC_WRAPPER = "${cfg.package}/bin/sccache";
      SCCACHE_DIR = cfg.cacheDir;
      SCCACHE_CACHE_SIZE = cfg.cacheSize;
      CARGO_INCREMENTAL = "0";
    };

    systemd.user.services.sccache = {
      Unit = {
        Description = "sccache — shared Rust build cache";
        After = [ "default.target" ];
      };

      Service = {
        Type = "forking";
        ExecStart = "${cfg.package}/bin/sccache --start-server";
        ExecStop = "${cfg.package}/bin/sccache --stop-server";
        Restart = "on-failure";

        Environment = [
          "SCCACHE_DIR=${cfg.cacheDir}"
          "SCCACHE_CACHE_SIZE=${cfg.cacheSize}"
          "SCCACHE_IDLE_TIMEOUT=0" # never auto-stop
          "SCCACHE_LOG=warn"
        ];

        StateDirectory = "sccache";
        StateDirectoryMode = "0700";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
