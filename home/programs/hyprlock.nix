{lib, ...}: {
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

        # Override Stylix and make it transparent
        outer_color = lib.mkForce "rgba(0,0,0,0)";
        inner_color = lib.mkForce "rgba(0,0,0,0)";
        check_color = lib.mkForce "rgba(0,0,0,0)";

        placeholder_text = "";

        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = true;
      };

      label = [
        {
          text = "$TIME";
          font_size = 75;
          position = "0, 200";
          valign = "center";
          halign = "center";
        }
        {
          text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 22;
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
