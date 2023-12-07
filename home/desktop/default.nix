{pkgs, ...}: {
  imports = [
    ./alacritty
    ./dunst
    ./firefox
    ./hyprland
    ./mpv
    ./rofi
    ./theme
    ./waybar
    ./wlsunset
  ];

  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
  };
}
