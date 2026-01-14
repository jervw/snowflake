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
      package = pkgs.rose-pine-hyprcursor;
      name = "BreezeX-RosePine-Linux";
      size = 24;
      gtk.enable = true;
    };

    ## GTK
    gtk = {
      enable = true;
      colorScheme = "dark";
      #font = {}; # TODO
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };

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
