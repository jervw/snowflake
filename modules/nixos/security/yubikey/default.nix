{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.security.yubikey;
in {
  options.${namespace}.security.yubikey = {
    enable = lib.mkEnableOption "Enable Yubikey authentication";
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [pkgs.yubikey-personalization];
    environment.systemPackages = [pkgs.yubikey-manager];
    programs.yubikey-touch-detector.enable = true;

    security.pam = {
      services = {
        sudo.u2fAuth = true;
        sudo-rs.u2fAuth = true;
      };
      u2f = {
        enable = true;
        control = "sufficient";
        settings.cue = true;
      };
    };
  };
}
