{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.mpd;
in {
  options.${namespace}.services.mpd = {
    enable = mkEnableOption "Enable mpd service";
  };

  config = mkIf cfg.enable {
    services = {
      mpd = {
        enable = true;
      };
      mpd-discord-rpc = {
        enable = true;
      };
    };
  };
}
