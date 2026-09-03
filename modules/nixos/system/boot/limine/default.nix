{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkDefault mkIf;

  cfg = config.${namespace}.system.boot;
in {
  config = mkIf (cfg.enable && cfg.loader == "limine") {
    boot.loader.limine = {
      enable = true;
      enableEditor = mkDefault false;
      maxGenerations = mkDefault cfg.generationLimit;
      secureBoot.enable = cfg.secureBoot;
    };
  };
}
