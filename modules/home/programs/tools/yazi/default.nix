{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.yazi;
in {
  options.${namespace}.programs.tools.yazi = {
    enable = lib.mkEnableOption "Enable yazi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ffmpegthumbnailer
      poppler
    ];

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
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
  };
}
