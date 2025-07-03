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
      "time1.google.com"
      "time2.google.com"
      "time3.google.com"
      "time4.google.com"
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
