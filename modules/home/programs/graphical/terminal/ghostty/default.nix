{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.terminal.ghostty;
in {
  options.${namespace}.programs.graphical.terminal.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      systemd.enable = true;
      settings = {
        window-decoration = false;
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

          # Split - New
          "ctrl+shift+s>h=new_split:left"
          "ctrl+shift+s>j=new_split:down"
          "ctrl+shift+s>k=new_split:up"
          "ctrl+shift+s>l=new_split:right"

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
