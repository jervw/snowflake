{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  environment = {
    sessionVariables = {
      EGL_PLATFORM = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      # Using x11 on all electron apps until electron 34/35 which should properly implement explicit sync
      # NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "x11";
    };

    systemPackages = with pkgs; [
      grimblast
      wl-clipboard
      wlr-randr
      hyprpicker
      xorg.xeyes
      xorg.xrandr
      xclip
    ];
  };

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
