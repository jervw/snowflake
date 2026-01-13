{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.virtualisation.docker;
in {
  options.${namespace}.virtualisation.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      docker-compose
      distrobox
      lazydocker
    ];

    virtualisation.oci-containers.backend = "docker";
    virtualisation.docker = {
      enable = true;
    };

    snowflake.user.extraGroups = ["docker"];
  };
}
