{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;

  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.theme.stylix;
in {
  options.${namespace}.theme.stylix = {
    enable = mkEnableOption "stylix theme for applications";
    theme = mkOpt types.str "decaf" "base16 theme file name";
    cursor = {
      name = mkOpt types.str "Dracula-cursors" "The name of the cursor theme to apply.";
      package = mkOpt types.package pkgs.dracula-theme "The package to use for the cursor theme.";
      size = mkOpt types.int 16 "The size of the cursor.";
    };
    icon = {
      name = mkOpt types.str "Adwaita" "The name of the icon theme to apply.";
      package = mkOpt types.package pkgs.adwaita-icon-theme "The package to use for the icon theme.";
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;

      # TODO: Add to module options
      image = pkgs.fetchurl {
        url = "https://r2.jervw.dev/wallhaven-9mg5zd.png";
        sha256 = "60b6a9522d22c452c9b20cb17b875cd6fdfd1fb7ae5b1a1087031e1ba791353a";
      };

      polarity = "dark";
    };
  };
}
