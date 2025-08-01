{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.system.systemd;
in {
  options.${namespace}.system.systemd = {
    enable = lib.mkEnableOption "systemd configuration";
  };

  config = mkIf cfg.enable {
    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}
