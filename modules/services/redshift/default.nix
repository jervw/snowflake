{ config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.xsession.enable) {      # Only evaluate code if using X11
    services = {
      redshift = {
        enable = true;
        temperature.night = 3000;
        latitude = 60.192059;
        longitude = 24.945831;
      };
    };
  }; 
}
