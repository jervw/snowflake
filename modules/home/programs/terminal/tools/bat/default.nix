{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.tools.bat;
in {
  options.${namespace}.programs.terminal.tools.bat = {
    enable = lib.mkEnableOption "Enable bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };
  };
}
