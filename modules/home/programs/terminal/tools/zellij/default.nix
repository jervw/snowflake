{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.tools.zellij;
in {
  options.${namespace}.programs.terminal.tools.zellij = {
    enable = lib.mkEnableOption "Enable Zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        simplified_ui = true;
        pane_frames = false;
        show_startup_tips = false;
        show_release_notes = false;
      };
    };
  };
}
