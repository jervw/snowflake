{ hyprland, pkgs, lib, ... }:

{
  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';

    variables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      # proprietary nvidia drivers require these
      WLR_NO_HARDWARE_CURSORS = "1";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      wlr-randr
      foot
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
  };

}
