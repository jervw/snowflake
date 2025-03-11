{pkgs, ...}: {
  services.blueman.enable = false;
  hardware.bluetooth = {
    enable = false;
    package = pkgs.bluez5-experimental;
    settings = {
      General = {
        ControllerMode = "bredr";
        FastConnectable = true;
        JustWorksRepairing = "always";
        Experimental = true;
      };
    };
  };
}
