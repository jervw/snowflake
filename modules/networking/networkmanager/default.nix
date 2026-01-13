{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.networking.networkmanager;
in {
  options.${namespace}.networking.networkmanager = {
    enable = lib.mkEnableOption "Enable NetworkManager";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
      };
    };

    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  };
}
