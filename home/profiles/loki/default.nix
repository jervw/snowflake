{
  imports = [
    ../../core
    ../../desktop
    ../../wayland
    ../../theme
  ];

  wayland.windowManager.hyprland.settings = {
    input = {
      force_no_accel = true;
    };
  };
}
