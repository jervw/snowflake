{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.term.ghostty;
in {
  options.${namespace}.programs.term.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      systemd.enable = true;
      settings = {
        theme = "Zenbones Dark";
        background-opacity = 0.9;
        window-decoration = false;
        window-inherit-working-directory = false;
        confirm-close-surface = false;
        quit-after-last-window-closed = false;
        auto-update = "off";
        quick-terminal-position = "center";

        keybind = [
          # Tabs
          "ctrl+t=new_tab"
          "ctrl+w=close_tab"
          "ctrl+shift+h=previous_tab"
          "ctrl+shift+l=next_tab"

          # Split - New # NOTE: key 's' would be better but conflicts with Helix
          "ctrl+a>h=new_split:left"
          "ctrl+a>j=new_split:down"
          "ctrl+a>k=new_split:up"
          "ctrl+a>l=new_split:right"
          "ctrl+a>w=close_surface"

          # Split - Move
          "alt+h=goto_split:left"
          "alt+j=goto_split:bottom"
          "alt+k=goto_split:top"
          "alt+l=goto_split:right"

          # Split - Resize
          "alt+ctrl+h=resize_split:left,20"
          "alt+ctrl+j=resize_split:down,20"
          "alt+ctrl+k=resize_split:up,20"
          "alt+ctrl+l=resize_split:right,20"

          # Misc
          "global:super+tab=toggle_quick_terminal"
          "alt+q=close_surface"
          "ctrl+shift+r=reload_config"
        ];
      };
    };
  };
}
