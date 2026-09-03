{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkOption types;

  cfg = config.${namespace}.system.boot;
in {
  options.${namespace}.system.boot = {
    enable = lib.mkEnableOption "boot configuration";
    loader = mkOption {
      type = types.enum ["limine" "systemd-boot"];
      default = "systemd-boot";
      description = "Bootloader to use";
    };
    generationLimit = mkOption {
      type = types.nullOr types.int;
      default = 5;
      description = "Maximum number of boot generations to retain";
    };
    timeout = mkOption {
      type = types.nullOr types.int;
      default = 2;
      description = "Seconds before booting the default menu entry";
    };
    plymouth = lib.mkEnableOption "plymouth boot splash";
    secureBoot = lib.mkEnableOption "Secure Boot";
    silentBoot = lib.mkEnableOption "silent boot";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.secureBoot || cfg.loader == "limine";
        message = "Secure Boot is only supported with the Limine bootloader.";
      }
    ];

    boot = {
      kernelParams =
        lib.optionals (cfg.plymouth || cfg.silentBoot) ["quiet"]
        ++ lib.optionals cfg.plymouth ["bgrt_disable"]
        ++ lib.optionals cfg.silentBoot [
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "systemd.show_status=auto"
          "rd.systemd.show_status=auto"
          "vt.global_cursor_default=0"
        ];

      initrd.verbose = lib.mkDefault (!cfg.silentBoot);
      consoleLogLevel = lib.mkIf cfg.silentBoot (lib.mkDefault 0);

      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
        timeout = lib.mkDefault cfg.timeout;
      };

      plymouth = {
        enable = cfg.plymouth;
      };
    };
  };
}
