{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.security.sudo;
in {
  options.${namespace}.security.sudo = {
    enable = lib.mkEnableOption "Replacing sudo with sudo-rs";
  };

  config = lib.mkIf cfg.enable {
    security.sudo.enable = false;
    security.sudo-rs = {
      enable = true;
      wheelNeedsPassword = true;
      execWheelOnly = true;
      extraConfig = ''
        # Hardening
        Defaults use_pty
        Defaults passwd_tries=3

        # General
        Defaults pwfeedback
        Defaults timestamp_timeout=10
      '';
    };
  };
}
