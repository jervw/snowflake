_: let
  font_family = "Inter";
in {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
      };

      background = [
        {
          monitor = "";
          path = "~/pics/walls/cyber.png";
          blur_passes = 2;
          blur_size = 2;
          vibrancy_darkness = 0.1;
        }
      ];

      input-field = [
        {
          monitor = "DP-1";
          size = "300, 50";
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

      label = [
        {
          monitor = "";
          text = "$TIME";
          inherit font_family;
          font_size = 75;
          position = "0, 100";
          valign = "center";
          halign = "center";
        }
      ];
    };
  };
}
