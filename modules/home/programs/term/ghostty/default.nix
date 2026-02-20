{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.term.ghostty;

  ghosttyCursorShaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "ghostty-cursor-shaders";
    rev = "4faa83e4b9306750fc8de64b38c6f53c57862db8";
    hash = "sha256-ruhEqXnWRCYdX5mRczpY3rj1DTdxyY3BoN9pdlDOKrE=";
  };
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

        custom-shader-animation = "always";
        custom-shader = "${ghosttyCursorShaders}/cursor_warp.glsl";

        keybind = [
          # Tabs
          "ctrl+t=new_tab"
          "ctrl+q=close_tab"
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
