{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.term.foot;
in {
  options.${namespace}.programs.term.foot = {
    enable = lib.mkEnableOption "Enable foot";
  };

  config = mkIf cfg.enable {
    # Lets GIO (Thunar, xdg-open) launch Terminal=true apps like Helix
    xdg.terminal-exec = {
      enable = true;
      settings.default = ["foot.desktop"];
    };

    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "foot";
          # Match ghostty's defaults: embedded JetBrains Mono at 12pt, 2x2 padding.
          font = "JetBrainsMono Nerd Font:size=12";
          pad = "2x2";
          selection-target = "clipboard";
        };

        bell = {
          urgent = true;
          visual = true;
        };

        desktop-notifications = {
          command = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
        };

        scrollback = {
          lines = 10000;
          multiplier = 3;
        };

        cursor = {
          style = "beam";
          blink = "yes";
          beam-thickness = 2;
        };
      };
    };
  };
}
