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
      "0.fi.pool.ntp.org iburst offline"
      "1.fi.pool.ntp.org iburst"
      "2.fi.pool.ntp.org iburst"
      "3.fi.pool.ntp.org iburst"
    ];

    services.chrony = {
      enable = true;
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
