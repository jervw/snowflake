{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.starship;
in {
  options.${namespace}.programs.tools.starship = {
    enable = lib.mkEnableOption "Enable starship prompt";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
    };
  };
}
