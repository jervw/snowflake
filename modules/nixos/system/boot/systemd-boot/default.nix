{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkDefault mkIf;

  cfg = config.${namespace}.system.boot;
in {
  config = mkIf (cfg.enable && cfg.loader == "systemd-boot") {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = mkDefault cfg.generationLimit;
      consoleMode = mkDefault "max";
      editor = mkDefault false;
    };
  };
}
