{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.syncthing;
in {
  options.${namespace}.services.syncthing = {
    enable = mkEnableOption "Enable syncthing service";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          # Desktop
          loki = {
            id = "BDUDP4Q-HUNQ4YK-HTGNC5K-PHXJMDT-LW6YXBX-ALGJRFB-RTRTQ33-B6RSYAI";
            autoAcceptFolders = true;
          };
          # Server
          thor = {
            id = "J4JVFCR-ND6TGKN-AKRJ3LA-XUYAYLI-RPQBZO4-OWLILPZ-2LFJH5V-5VWNOQM";
            autoAcceptFolders = true;
          };
          # Laptop
          fenrir = {
            id = "DQVGT7E-XUBOX5G-WSAXS5R-TSTBGGF-32RLEVK-F73VZZP-5IMMIEO-E6FAHAT";
            autoAcceptFolders = true;
          };
          # Phone
          tyr = {
            id = "LF4JYTN-K6OF2N4-JTVUKTU-F5W65QQ-KBAZGXU-46HWVEO-P3VYVGY-SXYKMAM";
          };
        };

        folders = {
          "~/sync" = {
            id = "sync";
            devices = builtins.attrNames config.services.syncthing.settings.devices;
          };
        };

        options = {
          relaysEnabled = false;
          localAnnounceEnabled = false;
          urAccepted = -1;
        };
      };

      extraOptions = ["--no-default-folder"];
    };
  };
}
