{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.thunar;
in {
  options.${namespace}.programs.graphical.apps.thunar = {
    enable = lib.mkEnableOption "Enable Thuanr";
  };

  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    services.tumbler = {
      enable = true;
    };
  };
}
