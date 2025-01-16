_: let
  devices = ["loki" "thor"];
in {
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    settings = {
      devices = {
        loki = {
          id = "5JQOQEZ-EW42SJV-VZOA4TN-LAPYPYY-QDSRR6T-DTP3BC6-ZQGYTIH-YTTPVQQ";
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
