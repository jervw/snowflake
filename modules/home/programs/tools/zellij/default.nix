{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.zellij;
in {
  options.${namespace}.programs.tools.zellij = {
    enable = lib.mkEnableOption "Enable Zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        simplified_ui = false;
        pane_frames = false;
        show_startup_tips = false;
        show_release_notes = false;
      };
    };
  };
}
