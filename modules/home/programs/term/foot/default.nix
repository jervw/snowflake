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
    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "foot";
          font = "JetBrainsMono Nerd Font Propo:size=13";
          pad = "8x8 center";
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
