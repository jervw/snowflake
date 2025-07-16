{
  config,
  lib,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.redlib;
in {
  options.${namespace}.services.redlib = {
    enable = mkEnableOption "Enable Redlib service";
    host = mkOption {
      type = lib.types.str;
      default = "redlib.jervw.dev";
      description = "Reverse proxy host name for the Redlib service";
    };
  };

  # TODO: Add port configuration

  config = {
    age.secrets.reddit.file = "${inputs.self}/secrets/reddit.age"; # FIXME whats wrong with this not evaluating inside cfg.enable??
    services = mkIf cfg.enable {
      redlib = {
        enable = true;
        port = 8081;
        settings = {
          REDLIB_DEFAULT_SHOW_NSFW = "on";
          REDLIB_DEFAULT_USE_HLS = "on";
          REDLIB_DEFAULT_HIDE_HLS_NOTIFICATION = "on";
        };
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:8081
        import cloudflare
      '';
    };

    # Used for REDLIB_DEFAULT_SUBSCRIPTIONS, I prefer to keep my subs private
    systemd.services.redlib = {
      serviceConfig = {
        EnvironmentFile = [config.age.secrets.reddit.path];
      };
    };
  };
}
