{
  config,
  inputs,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.sparkyfitness;
  containerUid = config.users.users.containers.uid;
in {
  options.${namespace}.services.sparkyfitness = {
    enable = mkEnableOption "SparkyFitness fitness tracking service";

    host = mkOption {
      type = types.str;
      default = "fit.jervw.dev";
      description = "Reverse proxy host name for SparkyFitness";
    };

    port = mkOption {
      type = types.port;
      default = 3004;
      description = "Local host port for the SparkyFitness frontend";
    };

    version = mkOption {
      type = types.str;
      default = "v1.12.1";
      description = "Release tag for the SparkyFitness server and frontend images";
    };

    adminEmail = mkOption {
      type = types.str;
      default = "";
      description = "Email of the user that can access the admin panel";
    };
  };

  config = mkIf cfg.enable {
    ${namespace}.virtualisation.quadlet.enable = true;

    # Expected keys: POSTGRES_PASSWORD, SPARKY_FITNESS_DB_PASSWORD (same value),
    # SPARKY_FITNESS_APP_DB_PASSWORD, SPARKY_FITNESS_API_ENCRYPTION_KEY (openssl rand -hex 32),
    # BETTER_AUTH_SECRET. DB passwords are only read when Postgres first initialises.
    age.secrets.sparkyfitness-env = {
      file = "${inputs.self}/secrets/sparkyfitness-env.age";
      mode = "0400";
      owner = "containers";
      group = "containers";
    };

    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers networks volumes;
      envFile = config.age.secrets.sparkyfitness-env.path;
    in {
      networks.sparkyfitness = {
        rootlessConfig.uid = containerUid;
        networkConfig.interfaceName = "br-sparkyfitness";
      };

      volumes = {
        sparkyfitness-postgres.rootlessConfig.uid = containerUid;
        sparkyfitness-uploads.rootlessConfig.uid = containerUid;
        sparkyfitness-backup.rootlessConfig.uid = containerUid;
      };

      containers = {
        sparkyfitness-db = {
          rootlessConfig.uid = containerUid;

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
            TimeoutStartSec = "5min";
          };

          containerConfig = {
            name = "sparkyfitness-db";
            image = "docker.io/library/postgres:18.3-alpine";
            networks = [networks.sparkyfitness.ref];
            networkAliases = ["sparkyfitness-db"];
            environmentFiles = [envFile];
            environments = {
              POSTGRES_DB = "sparkyfitness_db";
              POSTGRES_USER = "sparky";
            };
            # Postgres 18 images keep data in a versioned subdirectory of /var/lib/postgresql.
            volumes = ["${volumes.sparkyfitness-postgres.ref}:/var/lib/postgresql"];

            healthCmd = "pg_isready -U sparky -d sparkyfitness_db";
            healthInterval = "10s";
            healthTimeout = "5s";
            healthStartPeriod = "30s";
            healthRetries = 10;
            notify = "healthy";
          };
        };

        sparkyfitness-server = {
          rootlessConfig.uid = containerUid;

          unitConfig = {
            After = [containers.sparkyfitness-db.ref];
            Requires = [containers.sparkyfitness-db.ref];
          };

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
            TimeoutStartSec = "5min";
          };

          containerConfig = {
            name = "sparkyfitness-server";
            image = "docker.io/codewithcj/sparkyfitness_server:${cfg.version}";
            networks = [networks.sparkyfitness.ref];
            networkAliases = ["sparkyfitness-server"];
            environmentFiles = [envFile];
            environments = {
              TZ = "Europe/Helsinki";
              NODE_ENV = "production";
              SPARKY_FITNESS_LOG_LEVEL = "ERROR";
              SPARKY_FITNESS_DB_HOST = "sparkyfitness-db";
              SPARKY_FITNESS_DB_PORT = "5432";
              SPARKY_FITNESS_DB_NAME = "sparkyfitness_db";
              SPARKY_FITNESS_DB_USER = "sparky";
              SPARKY_FITNESS_APP_DB_USER = "sparky_app";
              SPARKY_FITNESS_SERVER_PORT = "3010";
              SPARKY_FITNESS_FRONTEND_URL = "https://${cfg.host}";
              SPARKY_FITNESS_ADMIN_EMAIL = cfg.adminEmail;
            };
            volumes = [
              "${volumes.sparkyfitness-uploads.ref}:/app/SparkyFitnessServer/uploads"
              "${volumes.sparkyfitness-backup.ref}:/app/SparkyFitnessServer/backup"
            ];
            stopTimeout = 20;
          };
        };

        sparkyfitness-frontend = {
          rootlessConfig.uid = containerUid;

          unitConfig = {
            After = [containers.sparkyfitness-server.ref];
            Requires = [containers.sparkyfitness-server.ref];
          };

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
          };

          containerConfig = {
            name = "sparkyfitness-frontend";
            image = "docker.io/codewithcj/sparkyfitness:${cfg.version}";
            networks = [networks.sparkyfitness.ref];
            publishPorts = ["127.0.0.1:${toString cfg.port}:80/tcp"];
            environments = {
              SPARKY_FITNESS_FRONTEND_URL = "https://${cfg.host}";
              SPARKY_FITNESS_SERVER_HOST = "sparkyfitness-server";
              SPARKY_FITNESS_SERVER_PORT = "3010";
            };
          };
        };
      };
    };

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString cfg.port}
      import cloudflare
    '';
  };
}
