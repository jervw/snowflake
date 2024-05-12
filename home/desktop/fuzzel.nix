{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono";
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
      };
      colors = {
        background = "303030dd";
        text = "ffffffdd";
        match = "#3584E4dd";
        selection = "e0e0e0dd";
        selection-match = "#3584E4dd";
        border = "303030ff";
      };
    };
  };
}
