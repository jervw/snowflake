{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        size = 14;
      };

      window = {
        opacity = 0.9;
        padding = {
          x = 10;
          y = 10;
        };
      };
      dynamic_title = false;
      dynamic_padding = true;
      colors = {
        primary = {
          background = "0x161616";
          foreground = "0xf2f4f8";
        };

        cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };

        vi_mode_cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };

        normal = {
          black = "0x282828";
          red = "0xee5396";
          green = "0x25be6a";
          yellow = "0x08bdba";
          blue = "0x78a9ff";
          magenta = "0xbe95ff";
          cyan = "0x33b1ff";
          white = "0xdfdfe0";
        };

        bright = {
          black = "0x484848";
          red = "0xf16da6";
          green = "0x46c880";
          yellow = "0x2dc7c4";
          blue = "0x8cb6ff";
          magenta = "0xc8a5ff";
          cyan = "0x52bdff";
          white = "0xe4e4e5";
        };
      };
    };
  };
}
