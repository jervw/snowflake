{
  pkgs,
  lib,
  config,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/loginctl lock-session
      ${pkgs.hyprland}/bin/hyprctl dispatch dpms
    fi
  '';
in {
  # screen idle
  services.hypridle = {
    enable = true;
    beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
    lockCmd = lib.getExe config.programs.hyprlock.package;

    listeners = [
      {
        timeout = 300;
        onTimeout = suspendScript.outPath;
      }
    ];
  };
}
