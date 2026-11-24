{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.term.zellij;
in {
  options.${namespace}.programs.term.zellij = {
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

        terminal = {
          font = "JetBrainsMono Nerd Font";
          font_size = 12;
          opacity = 0.85;
          blur = true;
          padding = 4;
        };
      };
    };
  };
}
