{
  config,
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.redlib;

  redlib-latest = pkgs.redlib.overrideAttrs (old: {
    version = "0.36.0-latest";

    src = pkgs.fetchFromGitHub {
      owner = "redlib-org";
      repo = "redlib";
      rev = "2dc6b5f3c0db1f8e78a74048ba4550ba6202cb55";
      hash = "";
    };

    cargoHash = "";
  });
in {
  options.${namespace}.services.redlib = {
    enable = mkEnableOption "Enable Redlib service";
    host = mkOption {
      type = lib.types.str;
      default = "redlib.jervw.dev";
      description = "Reverse proxy host name for the Redlib service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 8081;
    };
  };

  config = {
    age.secrets.reddit.file = "${inputs.self}/secrets/reddit.age"; # TODO: FIX whats wrong with this not evaluating inside cfg.enable??
    services = mkIf cfg.enable {
      redlib = {
        enable = true;
        package = redlib-latest;
        port = cfg.port;
        settings = {
          REDLIB_DEFAULT_SHOW_NSFW = "on";
          REDLIB_DEFAULT_USE_HLS = "on";
          REDLIB_DEFAULT_HIDE_HLS_NOTIFICATION = "on";
        };
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
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
