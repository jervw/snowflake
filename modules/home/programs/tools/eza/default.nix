{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.eza;
in {
  options.${namespace}.programs.tools.eza = {
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
      tree = "eza --tree --icons";
    };
  };
}
