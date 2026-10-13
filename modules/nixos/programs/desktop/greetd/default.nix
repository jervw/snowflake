{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkIf mkOption;

  cfg = config.${namespace}.programs.desktop.greetd;
in {
  options.${namespace}.programs.desktop.greetd = {
    enable = lib.mkEnableOption "Enable greetd login-manager";
    sessions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of available sessions for tuigreet";
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          user = "greeter";
          command = "${pkgs.tuigreet}/bin/tuigreet --time -r --remember-session --cmd ${lib.escapeShellArg (builtins.head cfg.sessions)}";
        };
      };
    };

    # Unlock the keyring with the login password
    security.pam.services.greetd.enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;

    environment.etc."greetd/environments".text = lib.concatLines cfg.sessions;
  };
}
