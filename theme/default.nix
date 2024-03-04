{
  # convert rrggbb hex to #rrggbb
  x = c: "#${c}";

  colors = rec {
    bg0 = "131a24"; # Dark bg
    bg1 = "192330"; # Default bg
    bg2 = "212e3f"; # Lighter bg
    bg3 = "29394f"; # Lighter bg
    bg4 = "39506d"; # Conceal, border fg
    fg0 = "d6d6d7"; # Lighter fg
    fg1 = "cdcecf"; # Default fg
    fg2 = "aeafb0"; # Darker fg
    fg3 = "71839b"; # Darker fg
    sel0 = "2b3b51"; # Popup bg,
    sel1 = "3c5372"; # Popup sel bg,

    black = "393b44";
    red = "c94f6d";
    green = "81b29a";
    yellow = "dbc074";
    blue = "719cd6";
    magenta = "9d79d6";
    cyan = "63cdcf";
    white = "dfdfe0";

    black-bright = "575860";
    red-bright = "d16983";
    green-bright = "8ebaa4";
    yellow-bright = "e0c989";
    blue-bright = "86abdc";
    magenta-bright = "baa1e2";
    cyan-bright = "7ad4d6";
    white-bright = "e4e4e5";
  };
}
