{ lib, pkgs, ... }:

{
  services.dunst = {
  enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        alignment = "center";
        corner_radius = 5;
        follow = "mouse";
        font = "JetBrainsMono Nerd Font 10";
        format = "<b>%s</b>\\n%b";
        frame_width = 0;
        offset = "5x5";
        horizontal_padding = 8;
        icon_position = "left";
        indicate_hidden = "yes";
        markup = "yes";
        max_icon_size = 64;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        padding = 8;
        plain_text = "no";
        separator_color = "auto";
        separator_height = 1;
        show_indicators = false;
        shrink = "no";
        word_wrap = "yes";
      };

      fullscreen_delay_everything = { fullscreen = "delay"; };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#c6d0f5";
        timeout = 5;
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#c6d0f5";
        timeout = 6;
      };
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#c6d0f5";
        frame_color = "#ea999c";
        timeout = 0;
      };
    };
  };
}

