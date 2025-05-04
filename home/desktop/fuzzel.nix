_: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "foot -e";
        layer = "overlay";
      };
      border = {
        radius = 15;
        width = 3;
      };
    };
  };
}
