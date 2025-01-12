{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.ghostty}/bin/ghostty -e";
        layer = "overlay";
      };
      border = {
        radius = 15;
        width = 3;
      };
    };
  };
}
