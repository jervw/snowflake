{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.security.doas;
in {
  options.${namespace}.security.doas = {
    enable = lib.mkEnableOption "replacing sudo with doas";
  };

  config = lib.mkIf cfg.enable {
    security.sudo.enable = lib.mkForce false;
    security.doas = {
      enable = true;
      extraRules = [
        {
          groups = ["wheel"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };
}
