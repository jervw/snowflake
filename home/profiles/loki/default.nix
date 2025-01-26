{
  imports = [
    ../../core
    ../../desktop
    ../../programs
    ../../services
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",highrr,auto,1"
      "HDMI-A-1,preferred,auto-left,1"
    ];
    workspace = [
      "1, monitor:HDMI-A-1, gapsin:5, gapsout:5, default:true"
      "2, monitor:DP-1, default:true"
      "3, monitor:DP-1"
      "4, monitor:DP-1"
      "5, monitor:DP-1"
    ];
    cursor = {
      default_monitor = "DP-1";
    };
    input = {
      force_no_accel = true;
    };
  };
}
