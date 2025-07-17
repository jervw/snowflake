{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.shell.fish;
in {
  options.${namespace}.programs.terminal.shell.fish = {
    enable = lib.mkEnableOption "Enable Fish shell";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting
      '';

      plugins = [
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
        {
          name = "sponge";
          inherit (pkgs.fishPlugins.sponge) src;
        }
        {
          name = "puffer";
          inherit (pkgs.fishPlugins.puffer) src;
        }
      ];
    };
  };
}
