{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.discord;
in {
  options.${namespace}.programs.apps.discord = {
    enable = lib.mkEnableOption "Enable Discord";
  };

  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
      discord = {
        equicord.enable = true;
        branch = "canary";
        krisp.enable = true;
        openASAR.enable = true;
      };
    };
  };
}
