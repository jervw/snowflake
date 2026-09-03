{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.hardware.airpods;
in {
  options.${namespace}.hardware.airpods.enable = lib.mkEnableOption "AirPods support";

  config = mkIf cfg.enable {
    # The Noctalia/Omarchy panel plugin needs the fork's status file and
    # additional control verbs. Keep using NixOS's librepods module so its
    # group and capability wrapper remain authoritative.
    nixpkgs.overlays = [
      (final: _prev: {
        librepods = final.${namespace}.librepods-omarchy;
      })
    ];

    snowflake = {
      hardware = {
        audio = enabled;
        bluetooth = {
          enable = true;
          autoConnect = true;
        };
      };
      user.extraGroups = ["librepods"];
    };

    hardware.bluetooth = {
      package = pkgs.bluez-experimental;
      settings.General = {
        # Advertise an Apple vendor ID for AirPods' Apple-specific features.
        DeviceID = "bluetooth:004C:0000:0000";
        Experimental = true;
      };
    };

    programs.librepods.enable = true;

    systemd.user.services.librepods = {
      description = "LibrePods AirPods daemon";
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      environment.QT_LOGGING_RULES = "openpods.debug=false";

      serviceConfig = {
        Type = "simple";
        ExecStart = "/run/wrappers/bin/librepods --headless";
        Restart = "on-failure";
        RestartSec = 5;

        UMask = "0077";
        StateDirectory = "librepods";
        StateDirectoryMode = "0700";
        ConfigurationDirectory = "AirPodsTrayApp";
        ConfigurationDirectoryMode = "0700";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ReadWritePaths = "%t";
        PrivateTmp = true;

        # The NixOS wrapper acquires CAP_NET_ADMIN when it is executed, so the
        # fork's NoNewPrivileges and empty CapabilityBoundingSet cannot be used.
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectClock = true;
        ProtectHostname = true;
        RestrictAddressFamilies = ["AF_UNIX" "AF_BLUETOOTH" "AF_NETLINK"];
      };
    };

    services.pipewire.wireplumber.extraConfig."51-airpods" = {
      "monitor.bluez.properties" = {
        # Required for play/pause/skip gestures to work reliably.
        "bluez5.dummy-avrcp-player" = true;

        # Keep AirPods in high-quality playback mode and do not expose a mic.
        "bluez5.roles" = ["a2dp_source"];
      };
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
        "bluetooth.profile-preference" = "quality";
      };
    };
  };
}
