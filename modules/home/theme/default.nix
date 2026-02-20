{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.theme;
in {
  options.${namespace}.theme = {
    enable = lib.mkEnableOption "Enable theming";
  };

  config = mkIf cfg.enable {
    ## Cursor
    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors-translucent;
      name = "Bibata_Ghost";
      size = 28;
      gtk.enable = true;
    };

    ## GTK
    gtk = {
      enable = true;
      colorScheme = "dark";
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };

      # We disable GTK4 theming to allow Noctalia to theme it
      gtk4.enable = false;

      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };

    dconf = {
      enable = true;
    };

    ## QT
    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };
    home.packages = [pkgs.qt6Packages.qt6ct];
  };
}
