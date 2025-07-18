{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.theme.stylix;
in {
  options.${namespace}.theme.stylix = {
    enable = lib.mkEnableOption "Enable stylix home-manager integration";
    theme = mkOpt types.str "decaf" "base16 theme file name";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
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
