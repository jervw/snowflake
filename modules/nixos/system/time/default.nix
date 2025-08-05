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
    networking.timeServers = [
      "0.fi.pool.ntp.org"
      "1.fi.pool.ntp.org"
      "2.fi.pool.ntp.org"
      "3.fi.pool.ntp.org"
    ];

    services.chrony = {
      enable = true;
      enableNTS = true;
    };

    # Make sure we can resolve the timeservers
    systemd.services.chronyd = {
      after =
        lib.optional config.services.resolved.enable "systemd-resolved.service"
        ++ lib.optional config.services.dnsmasq.enable "dnsmasq.service";
    };

    time.timeZone = "Europe/Helsinki";
  };
}
