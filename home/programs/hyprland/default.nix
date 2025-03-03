_: {
  imports = [./settings.nix ./binds.nix ./rules.nix];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enableXdgAutostart = true;
      variables = ["--all"];
    };
  };
}
