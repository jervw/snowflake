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
      }
    ];

    input-fields = [
      {
        monitor = "DP-1";

        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 2;

        outer_color = "rgb(${theme.colors.bg1})";
        inner_color = "rgb(${theme.colors.bg2})";
        font_color = "rgb(${theme.colors.fg1})";

        fade_on_empty = false;
        placeholder_text = ''<span font_family="${font_family}" foreground="##${theme.colors.fg1}">Password...</span>'';

        dots_spacing = 0.3;
        dots_center = true;
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        inherit font_family;
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
