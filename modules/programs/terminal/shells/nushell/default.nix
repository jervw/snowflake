{
  config,
  lib,
  pkgs,
  namespace,
  user,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.shells.nushell;
in {
  options.${namespace}.programs.terminal.shells.nushell = {
    enable = lib.mkEnableOption "Whether to enable nushell.";
    defaultShell = lib.mkEnableOption "Set nushell as default user shell.";
  };

  config = mkIf cfg.enable {
    hjem.users.${user}.rum.programs.nushell = {
      enable = true;

      # TODO Add aliases

      settings = {
        buffer_editor = "hx";
        show_banner = false;
        rm.always_trash = true;
      };
    };

    users.users.${user} = mkIf cfg.defaultShell {
      shell = pkgs.fish;
    };
  };
}
