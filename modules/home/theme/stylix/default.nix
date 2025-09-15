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
      cursor = cfg.cursor;

      iconTheme = {
        enable = true;
        inherit (cfg.icon) package;
        dark = cfg.icon.name;
        light = cfg.icon.name;
      };

      fonts = {
        sizes = {
          terminal = 13;
          desktop = 12;
          popups = 12;
        };

        serif = {
          package = pkgs.google-fonts.override {fonts = ["Inter"];};
          name = "Inter";
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Propo";
        };

        sansSerif = config.stylix.fonts.serif;
        emoji = config.stylix.fonts.monospace;
      };

      opacity = {
        desktop = 1.0;
        terminal = 0.8;
        popups = 0.8;
      };

      targets = {
        waybar.enable = false;
        zen-browser.profileNames = ["default"];
      };
    };
  };
}
