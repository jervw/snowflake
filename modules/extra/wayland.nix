{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        niri.default = ["gtk" "gnome"];
        hyprland.default = ["gtk" "hyprland"];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };
}
