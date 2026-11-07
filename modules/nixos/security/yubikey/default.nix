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
    services = {
      pcscd.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };

    environment.systemPackages = [pkgs.yubikey-manager pkgs.yubico-pam];

    programs.yubikey-touch-detector.enable = true;

    security.pam.u2f = {
      enable = true;
      settings.cue = true;
    };
  };
}
