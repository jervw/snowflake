{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.apps.flatpak;
in {
  options.${namespace}.programs.apps.flatpak = {
    enable = lib.mkEnableOption "Enable Flatpak";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
