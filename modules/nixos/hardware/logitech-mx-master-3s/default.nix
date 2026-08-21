{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.hardware.logitech-mx-master-3s;
in {
  options.${namespace}.hardware.logitech-mx-master-3s = {
    enable = lib.mkEnableOption "support for the Logitech MX Master 3S";
  };

  config = mkIf cfg.enable {
    hardware.uinput.enable = true;

    services.evdevremapkeys = {
      enable = true;
      settings.devices = [
        {
          input_name = "Logitech USB Receiver Mouse";
          output_name = "Logitech MX Master 3S remapped";
          remappings.BTN_FORWARD = ["KEY_LEFTMETA"];
        }
      ];
    };

    # hardware.uinput assigns /dev/uinput to the uinput group.
    users.users.evdevremapkeys.extraGroups = ["uinput"];
  };
}
