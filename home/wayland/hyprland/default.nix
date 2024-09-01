{pkgs, ...}: let
  term = "foot";
  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = toString (x + 1);
      in [
        "$MOD, ${ws}, workspace, ${ws}"
        "$MOD SHIFT, ${ws}, movetoworkspacesilent, ${ws}"
      ]
    )
    5);
in {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hyprspace
    ];
    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user start hyprland-session.target"
      ];
    };

    settings = {
      "$MOD" = "SUPER";
      exec-once = [
        "hyprlock"
        "sleep 2 && xrandr --output DP-1 --primary"
        "sleep 2 && wpaperd -d"
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
        gaps_in = 15;
        gaps_out = 15;
        border_size = 0;
        allow_tearing = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      render = {
        explicit_sync = 1;
        direct_scanout = true;
      };

      input = {
        kb_layout = "us,fi";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        force_no_accel = true;
        repeat_delay = 200;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(${term})$";
        vrr = 1;
      };

      decoration = {
        rounding = 15;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
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
          "specialWorkspace, 1, 6, default, slidefadevert -10%"
        ];
      };

      layerrule = [
        "ignorezero, waybar"
        "blur, waybar"
        "ignorezero, launcher"
        "blur, launcher"
        "noanim, launcher"
      ];

      windowrulev2 = [
        "noshadow, floating:0"
        "suppressevent maximize, class:^(zen-alpha)$"
        "float, title:^(Volume Control)$"
        "float, class:mpv"
        "float, title:^(Picture in picture)$"
        "workspace 1, class:(VencordDesktop)"
        "workspace special, class:(Cider)"
      ];

      bind =
        [
          "$MOD, Return, exec, ${term}"
          "$MOD, D, exec, killall fuzzel || fuzzel"
          "$MOD, X, exec, ${term} yazi"
          "$MOD, B, exec, zen"
          "$MOD, Z, exec, grimblast --notify --cursor copysave area"
          "$MOD CTRL, Z, exec, grimblast --notify --cursor copysave output"
          "$MOD, C, exec, hyprpicker -a | --autocopy"
          "$MOD SHIFT, E, exit"

          "$MOD, Q, killactive"
          "$MOD, F, fullscreen"
          "$MOD, Space, togglefloating"
          "$MOD, S, togglesplit"

          "$MOD, H, movefocus, l"
          "$MOD, L, movefocus, r"
          "$MOD, K, movefocus, u"
          "$MOD, J, movefocus, d"

          "$MOD SHIFT, H, movewindow, l"
          "$MOD SHIFT, L, movewindow, r"
          "$MOD SHIFT, K, movewindow, u"
          "$MOD SHIFT, J, movewindow, d"

          "ALT,Tab, changegroupactive"
          "$MOD, G, togglegroup"
          "$MOD, T, togglespecialworkspace"
          "$MOD SHIFT, T, movetoworkspacesilent, special"

          "$MOD, Tab, overview:toggle"
        ]
        ++ workspaces;

      binde = [
        "$MOD CTRL, H, resizeactive, -50 0"
        "$MOD CTRL, L, resizeactive, 50 0"
        "$MOD CTRL, K, resizeactive, 0 -50"
        "$MOD CTRL, J, resizeactive, 0 50"
      ];

      bindm = [
        "$MOD, mouse:272, movewindow"
        "$MOD, mouse:273, resizewindow"
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
