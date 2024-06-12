{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpegthumbnailer
    poppler
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      log = {
        enabled = false;
      };
    };
  };
}
