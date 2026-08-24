{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.bookorbit;
  containerUid = config.users.users.containers.uid;
  secretFile = "/var/lib/bookorbit/bookorbit.env";
in {
  options.${namespace}.services.bookorbit = {
    enable = mkEnableOption "BookOrbit self-hosted library service";

    host = mkOption {
      type = lib.types.str;
      default = "orbit.jervw.dev";
      description = "Reverse proxy host name for BookOrbit";
    };

    port = mkOption {
      type = lib.types.port;
      default = 3002;
      description = "Local host port for BookOrbit";
    };

    image = mkOption {
      type = lib.types.str;
      default = "ghcr.io/bookorbit/bookorbit:latest";
      description = "BookOrbit container image; pin a release tag or digest for reproducible deployments";
    };

    booksPath = mkOption {
      type = lib.types.path;
      default = "/mnt/storage/Media/Books";
      description = "Host book library mounted at /books";
    };

    nodeMaxOldSpaceSize = mkOption {
      type = lib.types.ints.positive;
      default = 2048;
      description = "Maximum Node.js heap size in MiB";
    };
  };

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = true;

    networking.firewall.interfaces = {
      br-bookorbit.allowedUDPPorts = [53];
      enp4s0.allowedTCPPorts = [cfg.port];
    };

    system.activationScripts.bookorbit-secrets = {
      deps = ["users" "groups"];
      text = ''
        ${pkgs.coreutils}/bin/install -d -m 0750 -o containers -g containers /var/lib/bookorbit

        if [ ! -s ${lib.escapeShellArg secretFile} ]; then
          secret_tmp="$(${pkgs.coreutils}/bin/mktemp /var/lib/bookorbit/bookorbit.env.XXXXXX)"
          trap '${pkgs.coreutils}/bin/rm -f "$secret_tmp"' EXIT

          {
            ${pkgs.coreutils}/bin/printf 'POSTGRES_PASSWORD=%s\n' "$(${lib.getExe pkgs.openssl} rand -hex 24)"
            ${pkgs.coreutils}/bin/printf 'JWT_SECRET=%s\n' "$(${lib.getExe pkgs.openssl} rand -hex 32)"
            ${pkgs.coreutils}/bin/printf 'SETUP_BOOTSTRAP_TOKEN=%s\n' "$(${lib.getExe pkgs.openssl} rand -hex 16)"
          } >"$secret_tmp"

          ${pkgs.coreutils}/bin/chown containers:containers "$secret_tmp"
          ${pkgs.coreutils}/bin/chmod 0400 "$secret_tmp"
          ${pkgs.coreutils}/bin/mv "$secret_tmp" ${lib.escapeShellArg secretFile}
          trap - EXIT
        fi

        ${pkgs.coreutils}/bin/chown containers:containers ${lib.escapeShellArg secretFile}
        ${pkgs.coreutils}/bin/chmod 0400 ${lib.escapeShellArg secretFile}
      '';
    };

    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers networks volumes;
    in {
      networks.bookorbit = {
        rootlessConfig.uid = containerUid;
        networkConfig.interfaceName = "br-bookorbit";
      };

      volumes = {
        bookorbit-app.rootlessConfig.uid = containerUid;
        bookorbit-postgres.rootlessConfig.uid = containerUid;
      };

      containers = {
        bookorbit-postgres = {
          autoStart = true;
          rootlessConfig.uid = containerUid;

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
            TimeoutStartSec = "5min";
          };

          containerConfig = {
            name = "bookorbit-db";
            image = "docker.io/pgvector/pgvector:pg18";
            networks = [networks.bookorbit.ref];
            networkAliases = ["postgres"];
            environmentFiles = [secretFile];
            environments = {
              POSTGRES_USER = "bookorbit";
              POSTGRES_DB = "bookorbit";
              PGDATA = "/var/lib/postgresql/data/pgdata";
            };
            volumes = [
              "${volumes.bookorbit-postgres.ref}:/var/lib/postgresql/data"
            ];

            healthCmd = "pg_isready -U bookorbit -d bookorbit";
            healthInterval = "10s";
            healthTimeout = "5s";
            healthStartPeriod = "20s";
            healthRetries = 10;
            notify = "healthy";
          };
        };

        bookorbit = {
          autoStart = true;
          rootlessConfig.uid = containerUid;

          unitConfig = {
            After = [containers.bookorbit-postgres.ref];
            Requires = [containers.bookorbit-postgres.ref];
            RequiresMountsFor = [cfg.booksPath];
          };

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
            TimeoutStartSec = "5min";
          };

          containerConfig = {
            name = "bookorbit-app";
            inherit (cfg) image;
            pull = "newer";
            runInit = true;
            networks = [networks.bookorbit.ref];
            networkAliases = ["app"];
            userns = "keep-id:uid=1000,gid=1000";
            addGroups = ["keep-groups"];
            publishPorts = [
              "127.0.0.1:${toString cfg.port}:3000/tcp"
              "10.0.0.3:${toString cfg.port}:3000/tcp"
            ];
            environmentFiles = [secretFile];
            environments = {
              NODE_ENV = "production";
              PORT = "3000";
              POSTGRES_HOST = "postgres";
              POSTGRES_PORT = "5432";
              POSTGRES_USER = "bookorbit";
              POSTGRES_DB = "bookorbit";
              APP_URL = "https://${cfg.host}";
              CLIENT_URL = "https://${cfg.host}";
              PUID = "1000";
              PGID = "1000";
              NODE_MAX_OLD_SPACE_SIZE = toString cfg.nodeMaxOldSpaceSize;
              LIBRARY_BROWSE_ROOT = "/books";
              OIDC_ALLOW_LOCAL_ISSUERS = "true";
            };
            volumes = [
              "${toString cfg.booksPath}:/books"
              "${volumes.bookorbit-app.ref}:/data"
            ];

            readOnly = true;
            tmpfses = ["/tmp"];
            dropCapabilities = ["ALL"];
            addCapabilities = [
              "CHOWN"
              "DAC_OVERRIDE"
              "FOWNER"
              "SETGID"
              "SETUID"
            ];
            noNewPrivileges = true;
            stopTimeout = 30;

            healthCmd = "node -e \"const p=process.env.PORT||3000;fetch('http://127.0.0.1:'+p+'/api/v1/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))\"";
            healthInterval = "30s";
            healthTimeout = "5s";
            healthStartPeriod = "20s";
            healthRetries = 3;
            healthOnFailure = "kill";
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
