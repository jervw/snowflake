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

      env = {
        TERM = "xterm-256color";
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
          background = "0x192330";
          foreground = "0xcdcecf";
        };

        normal = {
          black = "0x393b44";
          red = "0xc94f6d";
          green = "0x81b29a";
          yellow = "0xdbc074";
          blue = "0x719cd6";
          magenta = "0x9d79d6";
          cyan = "0x63cdcf";
          white = "0xdfdfe0";
        };

        bright = {
          black = "0x575860";
          red = "0xd16983";
          green = "0x8ebaa4";
          yellow = "0xe0c989";
          blue = "0x86abdc";
          magenta = "0xbaa1e2";
          cyan = "0x7ad5d6";
          white = "0xe4e4e5";
        };
      };
    };
  };
}
