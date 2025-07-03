{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.services.comin;
in {
  options.${namespace}.services.comin = {
    enable = lib.mkEnableOption "enable comin service";
  };

  config = lib.mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://codeberg.org/jervw/snowflake.git";
          branches.main.name = "main";
        }
      ];
    };
  };
}
