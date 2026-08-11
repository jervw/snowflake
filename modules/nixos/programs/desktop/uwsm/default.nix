{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.${namespace}.programs.desktop.uwsm;
in {
  options.${namespace}.programs.desktop.uwsm = {
    enable = mkEnableOption "uwsm";
    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to autostart uwsm";
    };
  };

  config = mkIf cfg.enable {
    programs.uwsm = {
      enable = true;
    };

    programs.fish.loginShellInit = mkIf cfg.autoStart ''
      if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
        exec uwsm start -g -1 default
      end
    '';
  };
}
