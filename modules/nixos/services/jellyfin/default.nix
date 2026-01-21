{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.jellyfin;
in {
  options.${namespace}.services.jellyfin = {
    enable = mkEnableOption "Enable Jellyfin service";
    host = mkOption {
      type = lib.types.str;
      default = "jellyfin.jervw.dev";
      description = "Reverse proxy host name for the Jellyfin service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 8096;
    };
  };

  config = mkIf cfg.enable {
    services = {
      jellyfin = {
        enable = true;
        openFirewall = true;
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };

    users.users.jellyfin.extraGroups = ["media"];
  };
}
