{
  config,
  inputs,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.grimmory;
  containerUid = config.users.users.containers.uid;
in {
  options.${namespace}.services.grimmory = {
    enable = mkEnableOption "Grimmory ebook, comic, and audiobook library";

    host = mkOption {
      type = lib.types.str;
      default = "books.jervw.dev";
      description = "Reverse proxy host name for Grimmory";
    };

    port = mkOption {
      type = lib.types.port;
      default = 6060;
      description = "Host port for Grimmory";
    };

    libraryPath = mkOption {
      type = lib.types.path;
      default = "/mnt/storage/Media";
      description = "Host media directory mounted at /books in Grimmory";
    };

    bookdropPath = mkOption {
      type = lib.types.path;
      default = "/mnt/storage/Media/Bookdrop";
      description = "Host directory mounted at /bookdrop for automatic imports";
    };
  };

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = true;

    age.secrets = {
      grimmory = {
        file = "${inputs.self}/secrets/grimmory.age";
        mode = "0400";
        owner = "containers";
        group = "containers";
      };

      grimmory-database = {
        file = "${inputs.self}/secrets/grimmory-database.age";
        mode = "0400";
        owner = "containers";
        group = "containers";
      };
    };

    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers networks volumes;
    in {
      networks.grimmory.rootlessConfig.uid = containerUid;

      volumes = {
        grimmory-data.rootlessConfig.uid = containerUid;
        grimmory-database.rootlessConfig.uid = containerUid;
      };

      containers = {
        grimmory-database = {
          autoStart = true;
          rootlessConfig.uid = containerUid;

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
            TimeoutStartSec = "15min";
          };

          containerConfig = {
            image = "lscr.io/linuxserver/mariadb:11.4.5";
            networks = [networks.grimmory.ref];
            environmentFiles = [config.age.secrets.grimmory-database.path];
            environments = {
              PUID = "1000";
              PGID = "1000";
              TZ = "Europe/Helsinki";
              MYSQL_DATABASE = "grimmory";
              MYSQL_USER = "grimmory";
            };
            volumes = ["${volumes.grimmory-database.ref}:/config"];

            healthCmd = "mariadb-admin ping -h localhost";
            healthInterval = "5s";
            healthTimeout = "5s";
            healthRetries = 10;
            notify = "healthy";
          };
        };

        grimmory = {
          autoStart = true;
          rootlessConfig.uid = containerUid;

          unitConfig = {
            After = [containers.grimmory-database.ref];
            Requires = [containers.grimmory-database.ref];
          };

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
          };

          containerConfig = {
            image = "ghcr.io/grimmory-tools/grimmory:latest";
            networks = [networks.grimmory.ref];
            publishPorts = ["${toString cfg.port}:6060/tcp"];
            addGroups = ["keep-groups"];
            environmentFiles = [config.age.secrets.grimmory.path];
            environments = {
              USER_ID = "1000";
              GROUP_ID = "1000";
              TZ = "Europe/Helsinki";
              DATABASE_URL = "jdbc:mariadb://grimmory-database:3306/grimmory";
              DATABASE_USERNAME = "grimmory";
              API_DOCS_ENABLED = "false";
              DISK_TYPE = "LOCAL";
            };
            volumes = [
              "${volumes.grimmory-data.ref}:/app/data"
              "${toString cfg.libraryPath}:/books"
              "${toString cfg.bookdropPath}:/bookdrop"
            ];

            healthCmd = "wget -q -O - http://localhost:6060/api/v1/healthcheck";
            healthInterval = "60s";
            healthTimeout = "10s";
            healthStartPeriod = "60s";
            healthRetries = 5;
          };
        };
      };
    };

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://thor:${toString cfg.port}
      import cloudflare
    '';

    systemd.tmpfiles.rules = [
      "d ${cfg.bookdropPath} 2775 containers media -"
    ];
  };
}
