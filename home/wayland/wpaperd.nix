_: {
  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "30m";
        mode = "center";
      };
      any = {
        path = "/home/jervw/.dots/wallpapers";
        group = 1;
        apply-shadow = true;
      };
    };
  };
}
