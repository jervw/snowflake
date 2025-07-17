{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.tools.fzf;
in {
  options.${namespace}.programs.terminal.tools.fzf = {
    enable = lib.mkEnableOption "Enable fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      defaultCommand = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";

      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = true;
    };
  };
}
