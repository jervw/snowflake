{
  config,
  theme,
  ...
}: let
  font_family = "Inter";
in {
  programs.hyprlock = {
    enable = true;

    general.hide_cursor = false;

    backgrounds = [
      {
        monitor = "";
        path = "${config.home.homeDirectory}/.lock.png";
        blur_passes = 2;
        blur_size = 2;
        vibrancy_darkness = 0.1;
      }
    ];

    input-fields = [
      {
        monitor = "";

        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 2;

        outer_color = "rgba(40,40,40,0.0)";
        inner_color = "rgba(200, 200, 200, 0.8)";
        font_color = "rgba(10, 10, 10, 0.8)";

        fade_on_empty = false;
        placeholder_text = "Password...";

        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = true;
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        inherit font_family;
        font_size = 75;

        position = {
          x = 0;
          y = 100;
        };

        valign = "center";
        halign = "center";
      }
    ];
  };
}
