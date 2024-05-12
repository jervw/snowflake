_: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["~/.wall.png"];

      wallpaper = [
        "DP-1,~/.wall.png"
        "HDMI-A-1,~/.wall.png"
      ];
    };
  };
}
