{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.zathura;
in {
  options.${namespace}.programs.apps.zathura = {
    enable = lib.mkEnableOption "Enable zathura";
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      mappings = {
        "<A-a>" = "recolor";
        "j" = "feedkeys <C-Down>";
        "k" = "feedkeys <C-Up>";
      };
      options = {
        font = "JetBrainsMono Nerd Font 13";
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
