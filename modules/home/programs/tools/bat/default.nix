{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.bat;
in {
  options.${namespace}.programs.tools.bat = {
    enable = lib.mkEnableOption "Enable bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };
    home.shellAliases = {
      cat = "bat";
    };
  };
}
