{inputs, ...}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    kernelParams = ["quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3"];
    consoleLogLevel = 0;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    initrd = {
      verbose = false;
      systemd = {
        enable = true;
        enableTpm2 = true;
      };
    };
    loader = {
      timeout = 1;
    };
  };

  systemd.watchdog.rebootTime = "0";
}
