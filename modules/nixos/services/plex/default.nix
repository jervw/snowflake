{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.audiobookshelf;
in {
  options.${namespace}.services.plex = {
    enable = mkEnableOption "Enable Plex service";
    host = mkOption {
      type = lib.types.str;
      default = "plex.jervw.dev";
      description = "Reverse proxy host name for the Plex service";
    };
  };

  # TODO: Add port configuration

  config = mkIf cfg.enable {
    services = {
      plex = {
        enable = true;
        openFirewall = true;
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:32400
        import cloudflare
      '';
    };

    users.users.plex.extraGroups = ["media"];
  };
}
