_: let
  mod = "SUPER";
  modshift = "${mod}SHIFT";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    settings = {
      "$mod" = "SUPER";

      exec-once = [
        "systemctl --user import-environment"
        "xrandr --output DP-1 --primary"
        "waypaper --restore"
        "hyprlock"
      ];

      monitor = [
        ",highrr,auto,1"
        "HDMI-A-1,1920x1080@60,0x0,1,transform,3"
      ];

      workspace = [
        "1, monitor:DP-1"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, rounding:false, gapsin:0, gapsout:0, border:false, monitor:HDMI-A-1"
      ];

      general = {
        gaps_in = 10;
        gaps_out = 10;
        border_size = 0;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      input = {
        kb_layout = "us,fi";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        force_no_accel = true;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(foot)$";
      };

      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
        };

        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "2 2";
        shadow_range = 4;
        shadow_render_power = 2;
        "col.shadow" = "0x66000000";
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];
        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "windowsMove, 1, 4, default"
          "border, 1, 10, default"
          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces, 1, 6, default"
        ];

        layerrule = [
          "blur, rofi"
          "noanim, rofi"
        ];

        windowrulev2 = [
          "noshadow, floating:0"
          "float, title:^(Volume Control)$"
          "float, class:feh"
          "float, class:waypaper"
          "float, title:^(Picture in picture)$"
          "float, title:^(Steam)$"
          "float, title:^(Friends List)$"
          "float, title:^(Media viewer)$"
          "workspace 5, class:(VencordDesktop)"
          "workspace 5, class:(Cider)"
        ];
      };
    };
    extraConfig = ''
      # MISC BINDINGS
      bind = SUPER, Return, exec, foot
      bind = SUPER, D, exec, killall rofi || rofi -show drun
      bind = SUPER, B, exec, firefox
      bind = SUPER, Z, exec, slurp | grim -g - - | wl-copy
      bind = SUPER, C, exec, hyprpicker -a | --autocopy
      bind = SUPER SHIFT, E, exit

      # WINDOWS MANAGEMENT
      bind = SUPER, Q, killactive,
      bind = SUPER, F, fullscreen,
      bind = SUPER, Space, togglefloating,
      bind = SUPER, S, togglesplit,

      # FOCUS WINDOWS
      bind = SUPER, H, movefocus, l
      bind = SUPER, L, movefocus, r
      bind = SUPER, K, movefocus, u
      bind = SUPER, J, movefocus, d

      # MOVE WINDOWS
      bind = SUPER SHIFT, H, movewindow, l
      bind = SUPER SHIFT, L, movewindow, r
      bind = SUPER SHIFT, K, movewindow, u
      bind = SUPER SHIFT, J, movewindow, d

      # RESIZE WINDOWS
      bind = SUPER CTRL, H, resizeactive, -30 0
      bind = SUPER CTRL, L, resizeactive, 30 0
      bind = SUPER CTRL, K, resizeactive, 0 -30
      bind = SUPER CTRL, J, resizeactive, 0 l0

      # TABBED LAYOUT
      bind= SUPER, g, togglegroup
      bind= SUPER, tab, changegroupactive

      # SPECIAL (SCRATCHPAD)
      bind = SUPER, t, togglespecialworkspace
      bind = SUPER SHIFT, t, movetoworkspace, special

      # SWITCH
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5

      # MOVE
      bind = SUPER SHIFT, 1, movetoworkspacesilent, 1
      bind = SUPER SHIFT, 2, movetoworkspacesilent, 2
      bind = SUPER SHIFT, 3, movetoworkspacesilent, 3
      bind = SUPER SHIFT, 4, movetoworkspacesilent, 4
      bind = SUPER SHIFT, 5, movetoworkspacesilent, 5

      # MOUSE
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      bind = SUPER, mouse_down, workspace, e+1
      bind = SUPER, mouse_up, workspace, e-1
    '';
  };
}
