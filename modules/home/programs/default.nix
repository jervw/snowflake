{
  lib,
  namespace,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.${namespace}.programs.defaults = {
    terminal = mkOption {
      type = types.str;
      default = "foot";
      description = "Default terminal emulator launch command";
    };

    browser = mkOption {
      type = types.str;
      default = "zen";
      description = "Default web browser launch command";
    };

    launcher = mkOption {
      type = types.str;
      default = "pkill fuzzel || fuzzel";
      description = "Default launcher command";
    };

    lock = mkOption {
      type = types.str;
      default = lib.getExe config.programs.hyprlock.package;
      description = "Default lock command";
    };
  };
}
