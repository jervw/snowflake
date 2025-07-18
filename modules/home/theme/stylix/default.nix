{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.theme.stylix;
in {
  options.${namespace}.home.theme.stylix = {
    enable = lib.mkEnableOption "Enable stylix home-manager integration";
  };

  config = mkIf cfg.enable {
    stylix = {
      iconTheme = {
        enable = true;
        package = pkgs.adwaita-icon-theme;
        dark = "Adwaita";
        light = "Adwaita";
      };
      targets = {
        waybar.enable = false;
      };
    };
  };
}
