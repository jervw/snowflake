_: {
  boot = {
    plymouth = {
      enable = true;
    };
    kernelParams = [
      "quiet"
      "bgrt_disable"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    loader = {
      timeout = 4;
      systemd-boot.configurationLimit = 5;
      systemd-boot = {
        consoleMode = "max";
      };
    };
  };
}
