{
  config,
  lib,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.tinyauth;
in {
  options.${namespace}.services.tinyauth = {
    enable = mkEnableOption "Enable Tinyauth service";
    host = mkOption {
      type = lib.types.str;
      default = "auth.jervw.dev";
      description = "Reverse proxy host name for the Tinyauth service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 3333;
    };
  };

  config = mkIf cfg.enable {
    services = {
      tinyauth = {
        enable = true;
        environmentFile = config.age.secrets.tinyauth-env.path;
        settings = {
          APPURL = "https://${cfg.host}";
          SERVER_ADDRESS = "0.0.0.0";
          SERVER_PORT = cfg.port;
          AUTH_LOGINTIMEOUT = 0; # TODO: Remove
        };
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };

    age.secrets.tinyauth-env.file = "${inputs.self}/secrets/tinyauth-env.age";
  };
}
