{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  environment = {
    sessionVariables = {
      EGL_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1";

      # These two crash Hyprland 0.40 for some reason
      # WLR_BACKEND = "vulkan";
      # WLR_RENDERER = "vulkan";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    systemPackages = with pkgs; [
      grimblast
      wl-clipboard
      wlr-randr
      swww
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
    ];
  };
}
