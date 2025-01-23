_: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "ghostty -e";
        layer = "overlay";
      };
      border = {
        radius = 15;
        width = 3;
      };
    };
  };
}
