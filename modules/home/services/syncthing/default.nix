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
    versioning = mkIf cfg.versioning {
      type = "staggered";
      params.maxAge = toString (90 * 24 * 60 * 60); # 90 days
    };
  };
in {
  options.${namespace}.services.syncthing = {
    enable = mkEnableOption "Enable syncthing service";
    versioning = mkEnableOption "staggered versioning for all folders";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      # Use `ssh -L 8384:localhost:8384 <host>` for remote GUI access.
      guiAddress = "127.0.0.1:8384";
      guiCredentials = {
        username = "jervw";
        passwordFile = config.age.secrets.syncthing.path;
      };
      # Devices and folders are fully declarative; GUI changes are reverted.
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices =
          mapAttrs (_name: id: {
            inherit id;
            autoAcceptFolders = false;
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
