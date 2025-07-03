{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.networking.fail2ban;
in {
  options.${namespace}.networking.fail2ban = {
    enable = lib.mkEnableOption "enable fail2ban service";
  };
  # TODO Add configurable IP list

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      bantime = "2h";
      ignoreIP = [
        "10.0.0.0/26"
      ];
    };
  };
}
