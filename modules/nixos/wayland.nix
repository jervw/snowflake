{pkgs, ...}: {
  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      EGL_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1";

      WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    systemPackages = with pkgs; [
      grimblast
      wl-clipboard
      wlr-randr
      swww
      waypaper
      hyprpicker
      xorg.xeyes
      xorg.xrandr
      xclip
    ];
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };
}
