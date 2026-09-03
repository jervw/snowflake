{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.hardware.bluetooth;
in {
  options.${namespace}.hardware.bluetooth = {
    enable = lib.mkEnableOption "support for extra bluetooth devices";
    autoConnect = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to power on Bluetooth adapters and reconnect paired devices automatically";
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;

      powerOnBoot = cfg.autoConnect;

      settings = {
        General = {
          # Support both Classic Bluetooth and Bluetooth LE devices.
          ControllerMode = "dual";
        };
        Policy = {
          AutoEnable = cfg.autoConnect;
          ReconnectAttempts =
            if cfg.autoConnect
            then 7
            else 0;
          ReconnectIntervals = "1,2,4,8,16,32,64";
        };
      };
    };

    boot.kernelModules = ["btusb"];

    services.blueman = {
      enable = true;
    };
  };
}
