{
  config,
  inputs,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.audiobookshelf;
  providerCfg = cfg.providers.storytel;
in {
  options.${namespace}.services.audiobookshelf = {
    enable = mkEnableOption "Enable Audiobookshelf service";
    host = mkOption {
      type = lib.types.str;
      default = "shelf.jervw.dev";
      description = "Reverse proxy host name for the Audiobookshelf service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 8000;
    };

    providers.storytel.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Audiobookshelf Storytel provider";
    };
  };

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = mkIf providerCfg.enable true;

    services = {
      audiobookshelf = {
        enable = true;
        host = "127.0.0.1";
        group = "media";
        inherit (cfg) port;
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
        import cloudflare
      '';
    };

    age.secrets.abs-storytel-provider = mkIf providerCfg.enable {
      file = "${inputs.self}/secrets/abs-storytel-provider.age";
      mode = "0400";
      owner = "containers";
      group = "containers";
    };

    virtualisation.quadlet = mkIf providerCfg.enable {
      containers.abs-storytel-provider = {
        autoStart = true;
        rootlessConfig.uid = config.users.users.containers.uid;

        serviceConfig = {
          Restart = "always";
          RestartSec = "10s";
          NoNewPrivileges = true;
        };

        containerConfig = {
          image = "ghcr.io/revisor01/abs-storytel-provider:latest";
          publishPorts = ["127.0.0.1:4000:3000"];
          environmentFiles = [config.age.secrets.abs-storytel-provider.path];
        };
      };
    };
  };
}
