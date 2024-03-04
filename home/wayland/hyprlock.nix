_: {
  programs.hyprlock = {
    enable = true;

    general.hide_cursor = false;

    # backgrounds = [
    #   {
    #     monitor = "";
    #     path = "${config.home.homeDirectory}/wall.png";
    #   }
    # ];

    input-fields = [
      {
        monitor = "DP-1";

        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 2;

        fade_on_empty = false;

        dots_spacing = 0.3;
        dots_center = true;
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        font_family = "Inter";
        font_size = 50;

        position = {
          x = 0;
          y = 80;
        };

        valign = "center";
        halign = "center";
      }
    ];
  };
}
