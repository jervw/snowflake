{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.hardware.sony-inzone-h9-ii;

  zoneout = pkgs.${namespace}.zoneout;

  renameNode = kind: port: description: {
    matches = [{"node.name" = "~alsa_${kind}.usb-.*INZONE_H9_II.*${port}";}];
    actions.update-props = {
      "node.description" = description;
      "node.nick" = description;
    };
  };
in {
  options.${namespace}.hardware.sony-inzone-h9-ii = {
    enable = lib.mkEnableOption "support for the Sony INZONE H9 II";
    autostart = lib.mkEnableOption "the ZoneOut tray in the graphical session";
  };

  config = mkIf cfg.enable {
    nietos.hardware.audio = enabled;

    environment.systemPackages = [zoneout];

    # Grants the logged-in user access to the receiver's USB and hidraw nodes.
    services.udev.packages = [zoneout];

    # The receiver exposes separate game and chat outputs, which are only
    # available as individual sinks in the pro-audio profile.
    services.pipewire.wireplumber.extraConfig."51-inzone-h9-ii" = {
      "monitor.alsa.rules" = [
        {
          matches = [{"device.name" = "~alsa_card.usb-.*INZONE_H9_II.*";}];
          actions.update-props = {
            "device.profile" = "pro-audio";
            "api.acp.auto-profile" = false;
          };
        }
        (renameNode "output" "pro-output-0" "INZONE Secondary")
        (renameNode "output" "pro-output-1" "INZONE Primary")
        (renameNode "input" "pro-input-0" "INZONE Mic")
      ];
    };

    systemd.user.services.zoneout = mkIf cfg.autostart {
      description = "ZoneOut INZONE headset tray";
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe' zoneout "zoneout-gui"} --tray";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
