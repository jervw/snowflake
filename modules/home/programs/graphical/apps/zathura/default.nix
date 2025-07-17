{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.zathura;
in {
  options.${namespace}.programs.graphical.apps.zathura = {
    enable = lib.mkEnableOption "Enable zathura";
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      mappings = {
        "<A-a>" = "recolor";
      };
      options = {
        selection-notification = true;
        selection-clipboard = "clipboard";
        adjust-open = "best-fit";
        pages-per-row = "1";
        scroll-page-aware = "true";
        scroll-full-overlap = "0.01";
        scroll-step = "100";
        zoom-min = "10";
      };
    };
  };
}
