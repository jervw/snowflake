{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.terminal.foot;
in {
  options.${namespace}.programs.graphical.terminal.foot = {
    enable = lib.mkEnableOption "Enable foot";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "foot";
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
