{pkgs, ...}: {
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
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
