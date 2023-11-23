{...}: {
  boot = {
    kernelParams = ["quiet" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3"];
    consoleLogLevel = 0;
    plymouth.enable = true;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    loader = {
      timeout = 1;
    };
  };

  systemd.watchdog.rebootTime = "0";
}
