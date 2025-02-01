_: {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
      };

      background = {
        blur_passes = 4;
        blur_size = 2;
        vibrancy_darkness = 0.1;
      };

      input-field = {
        outline_thickness = 2;

        fade_on_empty = false;
        placeholder_text = "Password...";

        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = true;
      };

      label = {
        text = "$TIME";
        font_size = 75;
        position = "0, 200";
        valign = "center";
        halign = "center";
      };
    };
  };
}
