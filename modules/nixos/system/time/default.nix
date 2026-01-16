{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.system.time;
in {
  options.${namespace}.system.time = {
    enable = lib.mkEnableOption "time related settings";
  };

  config = mkIf cfg.enable {
    services.timesyncd = {
      enable = true;
      servers = [
        "0.pool.ntp.org"
        "1.pool.ntp.org"
        "2.pool.ntp.org"
      ];
    };

    # Ensure time sync happens before services that need it
    systemd.services.timesyncd.wantedBy = ["sysinit.target"];

    # Timezone
    time.timeZone = "Europe/Helsinki";
  };
}
