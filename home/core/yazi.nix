{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpegthumbnailer
    poppler
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        layout = [1 4 3];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        show_symlink = true;
      };
    };
  };
}
