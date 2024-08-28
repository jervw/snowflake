{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
  };
  environment = {
    sessionVariables = {
      EGL_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1";
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

  xdg = {
    portal = {
      enable = true;
      config.common.default = "*";
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = [
          "org.codeberg.dnkl.foot.desktop"
        ];
      };
    };
  };
}
