{
  pkgs,
  lib,
  config,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${lib.getExe pkgs.playerctl} -a status | ${lib.getExe pkgs.ripgrep} Playing -q
    if [ $? == 1 ]; then
      "${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms on";
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
      };
      listener = [
        {
          inherit timeout;
          on-timeout = suspendScript.outPath;
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
