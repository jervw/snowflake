{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.programs.apps.tether;
in {
  options.${namespace}.programs.apps.tether = {
    enable = mkEnableOption "Tether iPhone integration";

    bluetoothController = mkOption {
      type = types.nullOr (types.strMatching "hci[0-9]+");
      default = null;
      example = "hci0";
      description = "Bluetooth HCI controller Tether should use, or null for automatic selection";
    };
  };

  config = mkIf cfg.enable {
    services.avahi.publish = {
      enable = true;
      userServices = true;
    };

    programs.tether = {
      enable = true;

      wifi = {
        enable = true;
        openFirewall = true;
      };

      bluetooth =
        {enable = true;}
        // lib.optionalAttrs (cfg.bluetoothController != null) {
          adapters = [cfg.bluetoothController];
        };
    };
  };
}
