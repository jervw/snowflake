{
  pkgs,
  lib,
  config,
  ...
}: let
  # TODO Add actual suspend when NVIDIA fixes their shit
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${lib.getExe pkgs.playerctl} -a status | ${lib.getExe pkgs.ripgrep} Playing -q
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/loginctl lock-session
      ${config.wayland.windowManager.hyprland.package}/bin/hyprctl --instance 0 dispatch dpms off
    fi
  '';
  timeout = 300;
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        lock_cmd = lib.getExe config.programs.hyprlock.package;
        ignore_dbus_inhibit = true;
      };
      listener = [
        {
          inherit timeout;
          on-timeout = suspendScript.outPath;
        }
      ];
    };
  };
}
