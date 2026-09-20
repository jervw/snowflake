{
  config,
  lib,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mapAttrs;
  cfg = config.${namespace}.services.syncthing;

  deviceIds = {
    loki = "RHQ4D4W-IQ4YBW5-S3S6ESD-5E53RPV-K7LJ3CM-6XMLVAN-BMPZMAR-TL52FAX"; # Desktop
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
      guiCredentials = {
        username = "jervw";
        passwordFile = config.age.secrets.syncthing.path;
      };
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

        options = {
          relaysEnabled = false;
          localAnnounceEnabled = false;
          urAccepted = -1;
        };
      };
    };

    age.secrets.syncthing = {
      file = "${inputs.self}/secrets/syncthing.age";
      path = "${config.home.homeDirectory}/.local/state/agenix/syncthing";
    };
  };
}
