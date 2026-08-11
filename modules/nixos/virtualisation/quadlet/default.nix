{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.virtualisation.quadlet;
in {
  options.${namespace}.virtualisation.quadlet.enable =
    lib.mkEnableOption "Quadlet container services";

  config = mkIf cfg.enable {
    virtualisation = {
      podman.enable = true;
      quadlet.enable = true;
    };

    users.groups.containers = {};

    users.users.containers = {
      isSystemUser = true;
      uid = 990;
      home = "/var/lib/containers";
      createHome = true;
      group = "containers";
      extraGroups = ["media"];
      linger = true;
      autoSubUidGidRange = true;
    };
  };
}
