{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.graphical.wm.niri;
in {
  options.${namespace}.programs.graphical.wm.niri = {
    enable = lib.mkEnableOption "Enable Niri";
  };

  config = {
    services.noctalia-shell.enable = true;
    programs.niri = {
      enable = cfg.enable;
      package = pkgs.niri;
    };

    snowflake = mkIf cfg.enable {
      programs = {
        graphical = {
          display-managers = {
            greetd = {
              enable = true;
              command = "${config.programs.niri.package}/bin/niri-session &> /dev/null";
            };
          };
        };
      };
    };
  };
}
