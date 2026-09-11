{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.term.rio;
in {
  options.${namespace}.programs.term.rio.enable = lib.mkEnableOption "Enable Rio terminal";

  config = mkIf cfg.enable {
    programs.rio = {
      enable = true;

      settings = {
        theme = "noctalia";
        editor.program = "hx";
      };
    };
  };
}
