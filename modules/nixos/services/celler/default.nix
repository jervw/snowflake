{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.celler;

  garageStart = pkgs.writeShellScript "garage-celler-start" ''
    set -eu

    export GARAGE_DEFAULT_ACCESS_KEY="$AWS_ACCESS_KEY_ID"
    export GARAGE_DEFAULT_SECRET_KEY="$AWS_SECRET_ACCESS_KEY"

    exec ${lib.getExe pkgs.garage_2} server --single-node --default-bucket
  '';
in {
  options.${namespace}.services.celler = {
    enable = mkEnableOption "Celler Nix binary cache with Garage object storage";

    host = mkOption {
      type = lib.types.str;
      default = "cache.jervw.dev";
      description = "Public host name for the Celler cache";
    };

    port = mkOption {
      type = lib.types.port;
      default = 3904;
      description = "Local Celler HTTP port";
    };

    bucket = mkOption {
      type = lib.types.str;
      default = "celler";
      description = "Garage bucket used by Celler";
    };

    storagePath = mkOption {
      type = lib.types.path;
      default = "/mnt/extra/Celler";
      description = "Directory used for Garage object data";
    };

    s3Port = mkOption {
      type = lib.types.port;
      default = 3900;
      description = "Local Garage S3 API port";
    };

    retentionPeriod = mkOption {
      type = lib.types.str;
      default = "1 month";
      description = "Time unused cache objects are retained before garbage collection";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.celler = {
      file = "${inputs.self}/secrets/celler.age";
      mode = "0400";
    };

    services = {
      cellerd = {
        enable = true;
        environmentFile = config.age.secrets.celler.path;

        settings = {
          listen = "127.0.0.1:${toString cfg.port}";
          allowed-hosts = [cfg.host];
          api-endpoint = "https://${cfg.host}/";
          require-proof-of-possession = true;

          database.url = "sqlite:///var/lib/cellerd/server.db?mode=rwc";

          storage = {
            type = "s3";
            region = "garage";
            inherit (cfg) bucket;
            endpoint = "http://127.0.0.1:${toString cfg.s3Port}";
          };

          chunking = {
            nar-size-threshold = 64 * 1024;
            min-size = 16 * 1024;
            avg-size = 64 * 1024;
            max-size = 256 * 1024;
          };

          compression.type = "zstd";

          garbage-collection = {
            interval = "12 hours";
            default-retention-period = cfg.retentionPeriod;
          };

          jwt = {};
        };
      };

      garage = {
        enable = true;
        package = pkgs.garage_2;
        environmentFile = config.age.secrets.celler.path;

        settings = {
          metadata_dir = "/var/lib/garage/meta";
          data_dir = cfg.storagePath;
          db_engine = "sqlite";

          replication_factor = 1;

          rpc_bind_addr = "127.0.0.1:3901";
          rpc_public_addr = "127.0.0.1:3901";

          s3_api = {
            s3_region = "garage";
            api_bind_addr = "127.0.0.1:${toString cfg.s3Port}";
          };

          admin.api_bind_addr = "127.0.0.1:3903";
        };

        extraEnvironment.GARAGE_DEFAULT_BUCKET = cfg.bucket;
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
        import cloudflare
      '';
    };

    users = {
      groups.garage = {};
      users.garage = {
        isSystemUser = true;
        group = "garage";
      };
    };

    systemd = {
      services = {
        cellerd = {
          after = ["garage.service"];
          requires = ["garage.service"];
        };

        garage = {
          after = ["mnt-extra.mount"];
          requires = ["mnt-extra.mount"];
          serviceConfig = {
            DynamicUser = false;
            User = "garage";
            Group = "garage";
            ExecStart = lib.mkForce garageStart;
          };
        };
      };

      tmpfiles.rules = [
        "d ${cfg.storagePath} 0750 garage garage -"
      ];
    };
  };
}
