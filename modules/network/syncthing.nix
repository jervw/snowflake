{user, ...}: let
  devices = ["loki" "thor" "tyr" "vidar"];
in {
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];

  services.syncthing = {
    enable = false;
    inherit user;
    dataDir = "/home/${user}";
    guiAddress = "0.0.0.0:8384";

    settings = {
      devices = {
        "loki" = {id = "JTX7KJL-JHNZCZK-72J3M54-65FDZDM-WPR3HYA-VNKUBRZ-XWTYHZL-AYF7IQS";}; # Desktop
        "tyr" = {id = "LF4JYTN-K6OF2N4-JTVUKTU-F5W65QQ-KBAZGXU-46HWVEO-P3VYVGY-SXYKMAM";}; # Phone
        "thor" = {id = "SAE4MD3-Y5KFK4N-4SJTIA4-PRK7VMS-XPZMNR7-CNK5CTS-KBSJPKG-M45AOQM";}; # Server
        "vidar" = {id = "3QPRQIH-4TVAFO4-AKYWE3T-72TIBOB-37IGSBX-MV6X2BQ-5C5PQAC-5DFY7QD";}; # Windows (WSL)
      };

      folders = {
        "obsidian" = {
          path = "/home/${user}/sync/Obsidian";
          inherit devices;
        };
      };
    };
  };
}
