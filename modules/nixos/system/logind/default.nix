{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.system.logind;
in {
  options.${namespace}.system.logind = {
    enable = mkEnableOption "logind";
  };

  config = mkIf cfg.enable {
    services = {
      logind = {
        settings = {
          Login = {
            HandlePowerKey = "ignore";
            HandlePowerKeyLongPress = "poweroff";
            KillUserProcesses = true;
          };
        };
      };
    };
  };
}
