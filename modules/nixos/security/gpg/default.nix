{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.security.gpg;
in {
  options.${namespace}.security.gpg = {
    enable = lib.mkEnableOption "Enable GNUPG agent";
  };

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = lib.mkDefault pkgs.pinentry-tty;
      settings = {
        default-cache-ttl = 3600;
        max-cache-ttl = 3600;
      };
    };
  };
}
