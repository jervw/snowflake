_: let
  term = "foot";
  mod = "SUPER";

  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = toString (x + 1);
      in [
        "${mod}, ${ws}, workspace, ${ws}"
        "${mod} SHIFT, ${ws}, movetoworkspacesilent, ${ws}"
      ]
    )
    5);
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
      exec-once = [
        "hyprlock"
      ];

      monitor = [
        ",highrr,auto,1"
        "HDMI-A-1,preferred,auto-left,1"
      ];

      workspace = [
        "1, monitor:HDMI-A-1, rounding:false, gapsin:0, gapsout:0, border:false, default:true"
        "2, monitor:DP-1, default:true"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
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

      cursor = {
        default_monitor = "DP-1";
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(${term})$";
        vfr = false;
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
        "col.shadow" = "rgba(292c3cee)";
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
      };

      layerrule = [
        "noanim, launcher"
      ];

      windowrulev2 = [
        "noshadow, floating:0"
        "suppressevent maximize, class:^(firefox)$"
        "float, title:^(Volume Control)$"
        "float, class:feh"
        "float, title:^(Picture in picture)$"
        "float, title:^(Steam)$"
        "float, title:^(Friends List)$"
        "float, title:^(Media viewer)$"
        "workspace 1, class:(VencordDesktop)"
        "workspace 1, class:(Cider)"
      ];

      bind =
        [
          "${mod}, Return, exec, ${term}"
          "${mod}, D, exec, killall fuzzel || fuzzel"
          "${mod}, X, exec, ${term} yazi"
          "${mod}, B, exec, firefox"
          "${mod}, Z, exec, grimblast --notify --cursor copysave area"
          "${mod} CTRL, Z, exec, grimblast --notify --cursor copysave output"
          "${mod}, C, exec, hyprpicker -a | --autocopy"
          "${mod} SHIFT, E, exit"

          "${mod}, Q, killactive"
          "${mod}, F, fullscreen"
          "${mod}, Space, togglefloating"
          "${mod}, S, togglesplit"

          "${mod}, H, movefocus, l"
          "${mod}, L, movefocus, r"
          "${mod}, K, movefocus, u"
          "${mod}, J, movefocus, d"

          "${mod} SHIFT, H, movewindow, l"
          "${mod} SHIFT, L, movewindow, r"
          "${mod} SHIFT, K, movewindow, u"
          "${mod} SHIFT, J, movewindow, d"

          "${mod} CTRL, H, resizeactive, -30 0"
          "${mod} CTRL, L, resizeactive, 30 0"
          "${mod} CTRL, K, resizeactive, 0 -30"
          "${mod} CTRL, J, resizeactive, 0 l0"

          "${mod}, g, togglegroup"
          "${mod}, tab, changegroupactive"
          "${mod}, t, togglespecialworkspace"
          "${mod} SHIFT, t, movetoworkspace, special"
        ]
        ++ workspaces;
      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
      bindle = [
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise --max-volume 120"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower --max-volume 120"
      ];
    };
  };
}
