{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.tools.eza;
in {
  options.${namespace}.programs.terminal.tools.eza = {
    enable = lib.mkEnableOption "Enable eza";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      colors = "always";
      icons = "always";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    home.shellAliases = {
      lg = "lazygit";
      ls = "eza --icons";
      tree = "eza --tree --icons";
    };
  };
}
