_: let
  devices = ["loki" "thor"];
in {
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    settings = {
      devices = {
        loki = {
          id = "YGX7SCQ-2UR5DLG-EDXIBG7-B5UZNVT-CYWHDD6-7ER7G7S-2F6XAFP-CU4KMQT";
          autoAcceptFolders = true;
        };
        thor = {
          id = "J4JVFCR-ND6TGKN-AKRJ3LA-XUYAYLI-RPQBZO4-OWLILPZ-2LFJH5V-5VWNOQM";
          autoAcceptFolders = true;
        };
      };

      folders = {
        "~/sync" = {
          id = "sync";
          inherit devices;
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
