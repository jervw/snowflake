{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Noto Sans";
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
      };
      colors = {
        background = "282c34cc";
        text = "ffffffcc";
        match = "#3584E4cc";
        selection = "e0e0e0cc";
        selection-match = "#3584E4cc";
        border = "282c34cc";
      };
      border = {
        radius = 15;
      };
    };
  };
}
