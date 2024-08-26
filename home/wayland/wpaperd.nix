{self, ...}: {
  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "30m";
        mode = "center";
      };
      any = {
        path = "${self}/wallpapers";
        group = 1;
        apply-shadow = true;
      };
    };
  };
}
