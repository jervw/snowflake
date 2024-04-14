{...}: {
  programs.zellij = {
    enable = true;
    settings = {
      theme = "nightfox";
      simplified_ui = true;
      pane_frames = false;

      themes = {
        nightfox = {
          fg = "#cdcecf";
          bg = "#131a24";
          black = "#393b44";
          red = "#c94f6d";
          green = "#81b29a";
          yellow = "#dbc074";
          blue = "#719cd6";
          magenta = "#9d79d6";
          cyan = "#63cdcf";
          white = "#dfdfe0";
          orange = "#f4a261";
        };
      };
    };
  };
}
