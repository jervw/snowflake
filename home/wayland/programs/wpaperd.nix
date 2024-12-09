{self, ...}: {
  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "${self}/wallpapers";
        duration = "30m";
        group = 1;
      };
    };
  };
}
