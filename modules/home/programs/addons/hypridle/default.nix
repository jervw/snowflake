{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.addons.hypridle;
in {
  options.${namespace}.programs.addons.hypridle = {
    enable = lib.mkEnableOption "Enable Hypridle";
  };

  config = mkIf cfg.enable (
    let
      suspendScript = pkgs.writeShellScript "suspend-script" ''
        ${lib.getExe pkgs.playerctl} -a status | ${lib.getExe pkgs.ripgrep} Playing -q
        if [ $? == 1 ]; then
          ${pkgs.systemd}/bin/loginctl lock-session
          ${config.wayland.windowManager.hyprland.package}/bin/hyprctl --instance 0 dispatch dpms off
          ${config.programs.niri.package}/bin/niri msg action power-off-monitors
        fi
      '';
      timeout = 300;
    in {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
            lock_cmd = config.${namespace}.programs.defaults.lock;
            ignore_dbus_inhibit = false;
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
  );
}
