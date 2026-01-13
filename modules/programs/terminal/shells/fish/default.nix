{
  config,
  lib,
  pkgs,
  namespace,
  user,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.shells.fish;
in {
  options.${namespace}.programs.terminal.shells.fish = {
    enable = lib.mkEnableOption "Enable Fish shell";
    defaultShell = lib.mkEnableOption "Set fish as default user shell.";
  };

  config = mkIf cfg.enable {
    hjem.users.${user}.rum.programs.fish = {
      enable = true;

      # TODO Add aliases

      config = ''
        # Disable greeting
        set fish_greeting
      '';

      plugins = {
        inherit
          (pkgs.fishPlugins)
          fish-you-should-use
          done
          autopair
          sponge
          puffer
          ;
      };
    };

    programs.fish = {
      enable = true;
      useBabelfish = true;
    };
    users.users.${user} = mkIf cfg.defaultShell {
      shell = pkgs.fish;
    };
  };
}
