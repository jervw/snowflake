{
  config,
  lib,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.pocket-id;
in {
  options.${namespace}.services.pocket-id = {
    enable = mkEnableOption "Enable Pocket-ID service";
    host = mkOption {
      type = lib.types.str;
      default = "id.jervw.dev";
      description = "Reverse proxy host name for the Pocket-id service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 1411;
    };
  };

  config = mkIf cfg.enable {
    services = {
      pocket-id = {
        enable = true;
        settings = {
          HOST = "0.0.0.0";
          PORT = cfg.port;
          APP_URL = "https://${cfg.host}";
          TRUST_PROXY = true;
          ANALYTICS_DISABLED = true;
          ENCRYPTION_KEY_FILE = config.age.secrets.pocket-id.path;
        };
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };

    age.secrets.pocket-id = {
      file = "${inputs.self}/secrets/pocket-id.age";
      mode = "0400";
      owner = "pocket-id";
      group = "pocket-id";
    };
  };
}
