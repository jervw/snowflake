{
  namespace,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    env = [
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "EGL_PLATFORM,wayland"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "NIXOS_OZONE_WL,1"
    ];

    exec-once = [
      # config.${namespace}.programs.defaults.lock
      "eval $(gnome-keyring-daemon --start --components=secrets)"
    ];

    general = {
      gaps_in = 12;
      gaps_out = 10;
      allow_tearing = true;
      border_size = 3;
    };

    group = {
      groupbar = {
        height = 20;
        font_size = 12;
      };
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    opengl = {
      nvidia_anti_flicker = false;
    };

    input = {
      kb_layout = "us";
      kb_options = "caps:none";
      repeat_delay = 200;
    };

    misc = {
      disable_autoreload = true;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      animate_manual_resizes = true;
      key_press_enables_dpms = true;
      enable_swallow = true;
      swallow_regex = "^(foot)$";
      vrr = 1;
    };

    ecosystem = {
      no_update_news = true;
    };

    decoration = {
      rounding = 15;
      rounding_power = 4.0;
      blur = {
        enabled = true;
        size = 8;
        passes = 2;
        noise = 0.02;
      };
      shadow = {
        enabled = true;
        range = 4;
        offset = "2 2";
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "overshot, 0.05, 0.9, 0.1, 1.05"
        "smoothOut, 0.36, 0, 0.66, -0.56"
        "smoothIn, 0.25, 1, 0.5, 1"
      ];
      animation = [
        "windows, 1, 5, default"
        "windowsOut, 1, 4, default"
        "windowsMove, 1, 4, default"
        "border, 0"
        "workspaces, 1, 6, default"
      ];
    };
  };
}
