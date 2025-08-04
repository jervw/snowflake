{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.profilarr;
in {
  options.${namespace}.services.profilarr = {
    enable = mkEnableOption "Enable profilarr service";
    host = mkOption {
      type = lib.types.str;
      default = "profilarr.jervw.dev";
      description = "Reverse proxy host name for the profilarr service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 6868;
    };
    dataDir = mkOption {
      type = lib.types.path;
      default = "/var/lib/profilarr";
      description = "Directory for profilarr config volume.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.profilarr = {
      image = "santiagosayshey/profilarr:latest";
      ports = ["${toString cfg.port}:6868"];
      environment = {
        TZ = "Europe/Helsinki";
      };
      volumes = [
        "${cfg.dataDir}:/config"
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 1000 1000 - -"
    ];

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://thor:${toString cfg.port}
    '';
  };
}
