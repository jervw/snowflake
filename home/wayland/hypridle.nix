{
  lib,
  config,
  ...
}: let
  inherit (lib) getExe getExe';
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "${getExe config.programs.hyprlock.package}";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "${getExe config.programs.hyprlock.package}";
        }
        {
          timeout = 600;
          on-timeout = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms off";
          on-resume = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms on";
        }
      ];
    };
  };
}
