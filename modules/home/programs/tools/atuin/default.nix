{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.tools.atuin;
in {
  options.${namespace}.programs.tools.atuin = {
    enable = lib.mkEnableOption "Enable atuin";
  };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        ai.enabled = true;
      };
      # TODO: Switch to selfhosted history sync when AI features become paid.
    };
  };
}
