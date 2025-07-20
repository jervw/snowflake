{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.rmpc;
in {
  options.${namespace}.programs.graphical.apps.rmpc = {
    enable = lib.mkEnableOption "Enable rmpc";
  };

  config = mkIf cfg.enable {
    programs.rmpc = {
      enable = true;
    };

    snowflake.services.mpd.enable = true;
  };
}
