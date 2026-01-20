{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mapAttrs;
  cfg = config.${namespace}.services.syncthing;

  deviceIds = {
    loki = "YUFTXMD-BC2B7AI-G4QEDF3-H7DY4JU-73WT4J3-6ZRXX4J-U2XHSCT-MX5X5Q5"; # Desktop
    thor = "J4JVFCR-ND6TGKN-AKRJ3LA-XUYAYLI-RPQBZO4-OWLILPZ-2LFJH5V-5VWNOQM"; # Server
    fenrir = "DQVGT7E-XUBOX5G-WSAXS5R-TSTBGGF-32RLEVK-F73VZZP-5IMMIEO-E6FAHAT"; # Laptop
    tyr = "LF4JYTN-K6OF2N4-JTVUKTU-F5W65QQ-KBAZGXU-46HWVEO-P3VYVGY-SXYKMAM"; # Phone
  };

  allDevices = builtins.attrNames deviceIds;

  mkFolder = path: {
    inherit path;
    devices = allDevices;
  };
in {
  options.${namespace}.services.syncthing = {
    enable = mkEnableOption "Enable syncthing service";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices =
          mapAttrs (_name: id: {
            inherit id;
            autoAcceptFolders = true;
          })
          deviceIds;

        folders = {
          docs = mkFolder "~/docs";
          music = mkFolder "~/music";
          pics = mkFolder "~/pics";
          vids = mkFolder "~/vids";
          other = mkFolder "~/other";
        };

        gui = {
          user = "user";
          # TODO add actual password, even if offsite access is not possible
          password = "apina123";
        };

        options = {
          relaysEnabled = false;
          localAnnounceEnabled = false;
          urAccepted = -1;
        };
      };
    };
  };
}
