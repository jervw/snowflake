{
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
  config = {
    services = {
      udiskie.enable = true;
    };
  };
}
