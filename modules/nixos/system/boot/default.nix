{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.system.boot;
in {
  options.${namespace}.system.boot = {
    enable = lib.mkEnableOption "enable systemd-boot";
    plymouth = lib.mkEnableOption "plymouth boot splash";
    secureBoot = lib.mkEnableOption "secure boot";
    silentBoot = lib.mkEnableOption "silent boot";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        efibootmgr
        efitools
        efivar
      ]
      ++ lib.optionals cfg.secureBoot [sbctl tpm2-tss];

    systemd.tpm2.enable = cfg.secureBoot;

    boot = {
      kernelParams =
        lib.optionals cfg.plymouth ["quiet" "bgrt_disable"]
        ++ lib.optionals cfg.silentBoot [
          "quiet"
          "loglevel=3"
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "systemd.show_status=auto"
          "rd.systemd.show_status=auto"
          "vt.global_cursor_default=0"
        ];

      initrd = {
        systemd = {
          enable = true;
          tpm2.enable = cfg.secureBoot;
          network.wait-online.enable = false;
        };
        verbose = !cfg.silentBoot;
      };

      consoleLogLevel = lib.mkDefault 0;

      lanzaboote = mkIf cfg.secureBoot {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      loader = {
        efi.canTouchEfiVariables = true;

        systemd-boot = {
          enable = lib.mkForce (!cfg.secureBoot);
          configurationLimit = 5;
          consoleMode = "max";
          editor = false;
        };

        timeout = 2;
      };

      plymouth = {
        enable = cfg.plymouth;
      };
    };
  };
}
