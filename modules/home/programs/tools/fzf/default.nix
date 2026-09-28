{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.fzf;
in {
  options.${namespace}.programs.tools.fzf = {
    enable = lib.mkEnableOption "Enable fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      historyWidget.command = ""; # Using atuin's history manager
      defaultCommand = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";
    };
  };
}
