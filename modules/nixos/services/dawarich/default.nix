{
  config,
  lib,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.dawarich;
in {
  options.${namespace}.services.dawarich = {
    enable = mkEnableOption "Enable Dawarich service";

    host = mkOption {
      type = lib.types.str;
      default = "timeline.jervw.dev";
      description = "Reverse proxy host name for the Dawarich service";
    };

    port = mkOption {
      type = lib.types.port;
      default = 3010;
      description = "Local web port for the Dawarich service";
    };
  };

  config = mkIf cfg.enable {
    services = {
      dawarich = {
        enable = true;
        configureNginx = false;
        localDomain = cfg.host;
        webPort = cfg.port;
        extraEnvFiles = [config.age.secrets.dawarich-env.path];
        environment.APPLICATION_PROTOCOL = "https";
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        route {
          root * ${config.services.dawarich.package}/public
          file_server {
            pass_thru
          }
          reverse_proxy http://127.0.0.1:${toString cfg.port}
        }

        import cloudflare
      '';
    };

    age.secrets.dawarich-env = {
      file = "${inputs.self}/secrets/dawarich-env.age";
      mode = "0400";
      owner = "dawarich";
      group = "dawarich";
    };
  };
}
