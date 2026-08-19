{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.services.wallos;
in {
  options.${namespace}.services.wallos = {
    enable = lib.mkEnableOption "Wallos service";

    host = lib.mkOption {
      type = lib.types.str;
      default = "wallos.jervw.dev";
      description = "Reverse proxy host name for the Wallos service";
    };

    port = lib.mkOption {
      type = lib.types.number;
      default = 8282;
      description = "Host port for the Wallos service";
    };
  };

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = true;

    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) volumes;
    in {
      volumes = {
        wallos-db = {};
        wallos-logos = {};
      };

      containers.wallos = {
        autoStart = true;
        rootlessConfig.uid = config.users.users.containers.uid;

        serviceConfig = {
          Restart = "always";
          RestartSec = "10s";
        };

        containerConfig = {
          image = "docker.io/bellamy/wallos:latest";
          publishPorts = ["127.0.0.1:${toString cfg.port}:80/tcp"];
          environments.TZ = "Europe/Helsinki";
          volumes = [
            "${volumes.wallos-db.ref}:/var/www/html/db"
            "${volumes.wallos-logos.ref}:/var/www/html/images/uploads/logos"
          ];
        };
      };
    };

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString cfg.port}
      import cloudflare
    '';
  };
}
