{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.bars.quickshell;
in {
  options.${namespace}.programs.graphical.bars.quickshell = {
    enable = lib.mkEnableOption "Enable quickshell";
  };

  config = mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.system}.default;
      settings = {};
    };

    snowflake = {
      programs = {
        defaults = {
          launcher = "noctalia-shell ipc call launcher toggle";
          lock = "noctalia-shell ipc call lockScreen lock";
        };
      };
    };
  };
}
