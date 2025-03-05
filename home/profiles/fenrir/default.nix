{lib, ...}: {
  imports = [
    ../../core
    ../../desktop
    ../../wayland
    ../../services
  ];

  # Workaround to fix issue with cursor scaling on HIDPI
  home.pointerCursor.gtk.enable = lib.mkForce false;

  wayland.windowManager.hyprland.settings = let
    accelpoints = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
  in {
    env = [
      "GDK_SCALE,1.6"
      "QT_SCALE_FACTOR,1.6"
      "ELM_SCALE,1.6"
      "XCURSOR_SIZE,32"
    ];
    monitor = [
      ", highres, auto, 1.6"
    ];
    device = {
      name = "bcm5974";
      accel_profile = accelpoints;
      scroll_points = accelpoints;
      clickfinger_behavior = true;
      natural_scroll = true;
    };

    animations.enabled = lib.mkForce false;

    decoration = {
      blur.enabled = lib.mkForce false;
      shadow.enabled = lib.mkForce false;
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_min_fingers = true; # min 3 fingers by default
    };

    bindle = [
      ", XF86MonBrightnessUp, exec, swayosd-client --device=acpi_video0 --brightness raise"
      ", XF86MonBrightnessDown, exec, swayosd-client --device=acpi_video0 --brightness lower"
      ", XF86KbdBrightnessUp, exec, swayosd-client --device=apple::kbd_backlight --brightness raise"
      ", XF86KbdBrightnessDown, exec, swayosd-client --device=apple::kbd_backlight --brightness lower"
    ];
  };
}
