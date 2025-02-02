{config, ...}: {
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
}
