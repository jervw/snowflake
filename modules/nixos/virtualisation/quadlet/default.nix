{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.virtualisation.quadlet;

  quadletContainers = lib.attrValues config.virtualisation.quadlet.containers;
  containerImages = lib.unique (
    lib.filter (image: image != null) (
      map (container: container.containerConfig.image) quadletContainers
    )
  );
  containerUnits = map (container: "${container._serviceName}.service") quadletContainers;

  quadletUpdate = pkgs.writeShellApplication {
    name = "quadlet-update";
    runtimeInputs = [
      pkgs.coreutils
      config.virtualisation.podman.package
      pkgs.systemd
      pkgs.util-linux
    ];
    text = ''
      if (( EUID != 0 )); then
        echo "quadlet-update must be run as root; use: sudo quadlet-update" >&2
        exit 1
      fi

      images=(${lib.escapeShellArgs containerImages})
      units=(${lib.escapeShellArgs containerUnits})

      if (( ''${#images[@]} == 0 )); then
        echo "No Quadlet container images are configured."
        exit 0
      fi

      cd ${lib.escapeShellArg config.users.users.containers.home}

      for image in "''${images[@]}"; do
        echo "Pulling $image"
        runuser --user containers -- env \
          HOME=${lib.escapeShellArg config.users.users.containers.home} \
          LOGNAME=containers \
          USER=containers \
          XDG_RUNTIME_DIR=/run/user/${toString config.users.users.containers.uid} \
          podman pull "$image"
      done

      echo "Restarting running Quadlet containers"
      systemctl try-restart "''${units[@]}"
    '';
  };
in {
  options.${namespace}.virtualisation.quadlet.enable =
    lib.mkEnableOption "Quadlet container services";

  config = mkIf cfg.enable {
    virtualisation = {
      podman.enable = true;
      quadlet.enable = true;
    };

    environment.systemPackages = [quadletUpdate];

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
