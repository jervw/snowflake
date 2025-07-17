{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.launchers.fuzzel;
in {
  options.${namespace}.programs.graphical.launchers.fuzzel = {
    enable = lib.mkEnableOption "Enable fuzzel";
  };

  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "foot -e";
          layer = "overlay";
        };
        border = {
          radius = 15;
          width = 3;
        };
      };
    };
  };
}
