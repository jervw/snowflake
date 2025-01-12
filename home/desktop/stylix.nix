{pkgs, ...}: {
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
}
