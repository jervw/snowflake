{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.theme.catppuccin;
in {
  options.${namespace}.theme.catppuccin = {
    enable = mkEnableOption "Enable Catppuccin theming.";
  };

  config = mkIf cfg.enable {
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };

    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      catppuccin = {
        enable = true;
        cursors.enable = true;
        kvantum.enable = true;
      };

      programs.noctalia-shell = {
        settings.colorSchemes.predefinedScheme = "Catppuccin";
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Catppuccin-GTK-Dark";
          package = pkgs.magnetic-catppuccin-gtk;
        };
        gtk3 = {
          extraConfig.gtk-application-prefer-dark-theme = true;
        };
      };

      home.pointerCursor = {
        gtk.enable = true;
        # name = "Catppuccin-Mocha-Light-Cursors";
        # package = pkgs.catppuccin-cursors.mochaLight;
        size = 24;
      };

      qt = {
        enable = true;
        platformTheme.name = "kvantum";
        style.name = "kvantum";
      };
    };
  };
}
