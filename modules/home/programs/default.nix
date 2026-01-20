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
      default = "uwsm app -- brave";
      description = "Default web browser launch command";
    };

    launcher = mkOption {
      type = types.str;
      default = "noctalia-shell ipc call launcher toggle";
      description = "Default launcher command";
    };

    lock = mkOption {
      type = types.str;
      default = "noctalia-shell ipc call lockScreen lock";
      description = "Default lock command";
    };
  };
}
