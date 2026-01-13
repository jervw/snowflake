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

    ignoreIP = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of IP addresses or CIDR ranges to ignore";
      example = ["127.0.0.1/8" "10.0.0.0/8" "192.168.0.0/16"];
    };
  };

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      bantime = "2h";
      inherit (cfg) ignoreIP;
    };
  };
}
