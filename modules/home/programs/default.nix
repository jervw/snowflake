{
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.${namespace}.programs.defaults = {
    terminal = mkOption {
      type = types.str;
      default = "ghostty +new-window";
      description = "Default terminal emulator launch command";
    };

    browser = mkOption {
      type = types.str;
      default = "uwsm app -- zen-twilight";
      description = "Default web browser launch command";
    };

    launcher = mkOption {
      type = types.str;
      default = "noctalia msg panel-toggle launcher";
      description = "Default launcher command";
    };
  };
}
