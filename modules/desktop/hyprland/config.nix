{ pkgs, ... }:

{
  home.file = {
    ".config/hypr/hyprland.conf".text = ''
# EXEC
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = swaybg -i ~/.nix-setup/.wallpaper/el-captain-rock-reflection.jpg

# MONITORS
monitor = DP-1,2560x1440@120,1080x0,1
monitor = HDMI-A-1,1920x1080@60,0x0,1,transform,3

# WORKSPACES
workspace = DP-1, 1
workspace = HDMI-A-1, 5

# INPUT 
input {
    follow_mouse = 1
}

# GENERAL
general {
    gaps_in=10
    gaps_out=10
    border_size=0
    no_border_on_floating = true
    layout = dwindle
}

# MISC
misc {
    disable_hyprland_logo = false
    disable_splash_rendering = false
    mouse_move_enables_dpms = true
    vfr = true
    enable_swallow = true
    swallow_regex = ^(foot)$
}

# DECORATION
decoration {

    # Corners
    rounding = 8
    multisample_edges = true

    # Opacity
    active_opacity = 1.0
    inactive_opacity = 1.0

    # Blur 
    blur = true
    blur_size = 3
    blur_passes = 3
    blur_new_optimizations = true

    # Shadows
    drop_shadow = true
    shadow_ignore_window = true
    shadow_offset = 2 2
    shadow_range = 4
    shadow_render_power = 2
    col.shadow = 0x66000000

    blurls = gtk-layer-shell
    # blurls = waybar
    blurls = lockscreen
}

# ANIMATIONS
animations {
    enabled = true
    bezier = overshot, 0.05, 0.9, 0.1, 1.05
    bezier = smoothOut, 0.36, 0, 0.66, -0.56
    bezier = smoothIn, 0.25, 1, 0.5, 1

    animation = windows, 1, 5, overshot, slide
    animation = windowsOut, 1, 4, smoothOut, slide
    animation = windowsMove, 1, 4, default
    animation = border, 1, 10, default
    animation = fade, 1, 10, smoothIn
    animation = fadeDim, 1, 10, smoothIn
    animation = workspaces, 1, 6, default

}

dwindle {
    no_gaps_when_only = false
    pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true # you probably want this
}

# WINDOW RULES
windowrule = float, file_progress
windowrule = float, confirm
windowrule = float, dialog
windowrule = float, download
windowrule = float, notification
windowrule = float, error
windowrule = float, splash
windowrule = float, confirmreset
windowrule = float, title:Open File
windowrule = float, title:branchdialog
windowrule = float, viewnior
windowrule = float, Viewnior
windowrule = float, feh
windowrule = float, pavucontrol-qt
windowrule = float, pavucontrol
windowrule = float, file-roller
windowrule = fullscreen, wlogout
windowrule = float, title:wlogout
windowrule = fullscreen, title:wlogout
windowrule = idleinhibit focus, mpv
windowrule = idleinhibit fullscreen, firefox
windowrule = float, title:^(Media viewer)$
windowrule = float, title:^(Volume Control)$
windowrule = float, title:^(Picture-in-Picture)$
windowrule = size 800 600, title:^(Volume Control)$
windowrule = move 75 44%, title:^(Volume Control)$


# MISC BINDINGS
bind = SUPER, Return, exec, alacritty
bind = SUPER, D, exec, killall rofi || rofi -show drun 
bind = SUPER, B, exec, firefox 

# WINDOWS MANAGEMENT
bind = SUPER, Q, killactive,
bind = SUPER SHIFT, E, exit,
bind = SUPER, F, fullscreen,
bind = SUPER SHIFT, Space, togglefloating,
bind = SUPER, P, pseudo, # dwindle
bind = SUPER, S, togglesplit, # dwindle

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
bind = SUPER CTRL, left, resizeactive, -20 0
bind = SUPER CTRL, right, resizeactive, 20 0
bind = SUPER CTRL, up, resizeactive, 0 -20
bind = SUPER CTRL, down, resizeactive, 0 20

# TABBED LAYOUT
bind= SUPER, g, togglegroup
bind= SUPER, tab, changegroupactive

# SPECIAL (SCRATCHPAD)
bind = SUPER, c, togglespecialworkspace
bind = SUPER SHIFT, c, movetoworkspace, special

# SWITCH
bind = SUPER, 1, workspace, 1
k
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5

# MOVE
bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
bind = SUPER SHIFT, 3, movetoworkspace, 3
bind = SUPER SHIFT, 4, movetoworkspace, 4
bind = SUPER SHIFT, 5, movetoworkspace, 5

# MOUSE
bindm = SUPER, mouse:272, movewindow
bindm = SUPER, mouse:273, resizewindow
bind = SUPER, mouse_down, workspace, e+1
bind = SUPER, mouse_up, workspace, e-1

    '';
  };
}
