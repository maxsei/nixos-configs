{ config, ... }:
{
  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server.http_listen_address = "127.0.0.1";
      server.http_listen_port = 3100;
      common = {
        path_prefix = "/var/lib/loki";
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory = "/var/lib/loki/rules";
        };
        replication_factor = 1;
        ring.kvstore.store = "inmemory";
      };
      schema_config.configs = [
        {
          from = "2024-01-01";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }
      ];
    };
  };

  services.alloy.enable = true;
  environment.etc."alloy/config.alloy".text = ''
    loki.relabel "journal" {
      forward_to = []
      rule {
        source_labels = ["__journal__systemd_unit"]
        target_label  = "unit"
      }
      rule {
        source_labels = ["__journal__hostname"]
        target_label  = "host"
      }
    }

    loki.source.journal "journal" {
      forward_to    = [loki.write.local.receiver]
      relabel_rules = loki.relabel.journal.rules
      labels        = { "job" = "journal" }
    }

    loki.write "local" {
      endpoint {
        url = "http://127.0.0.1:3100/loki/api/v1/push"
      }
    }
  '';

  sops.secrets."grafana-admin-password" = {
    owner = "grafana";
    group = "grafana";
  };
  sops.secrets."grafana-secret-key" = {
    owner = "grafana";
    group = "grafana";
  };

  services.grafana = {
    enable = true;
    settings.server = {
      http_addr = "0.0.0.0";
      http_port = 3000;
      domain = "annon.ts.maxsei.chickenkiller.com";
      root_url = "https://annon.ts.maxsei.chickenkiller.com/grafana/";
      serve_from_sub_path = true;
    };
    settings.security = {
      admin_user = "admin";
      admin_password = "$__file{${config.sops.secrets."grafana-admin-password".path}}";
      secret_key = "$__file{${config.sops.secrets."grafana-secret-key".path}}";
    };
    provision.datasources.settings = {
      apiVersion = 1;
      datasources = [
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:3100";
        }
      ];
    };
  };
}
