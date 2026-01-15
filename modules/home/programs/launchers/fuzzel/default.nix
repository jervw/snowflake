{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.launchers.fuzzel;
in {
  options.${namespace}.programs.launchers.fuzzel = {
    enable = lib.mkEnableOption "Enable fuzzel";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.bemoji];

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
