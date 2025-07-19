{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) types mkIf mkOption;

  cfg = config.${namespace}.programs.graphical.display-managers.greetd;
  user = config.${namespace}.user;
in {
  options.${namespace}.programs.graphical.display-managers.greetd = {
    enable = lib.mkEnableOption "Enable greetd login-manager";
    command = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The command to run for the greetd login-manager.";
    };
  };

  config = mkIf (cfg.enable && cfg.command != null) {
    services.greetd = let
      session = {
        user = user.name;
        command = cfg.command;
      };
    in {
      enable = true;
      settings = {
        default_session = session;
        initial_session = session;
      };
    };
  };
}
