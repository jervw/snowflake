{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.networking.ssh;

  # YubiKey OpenPGP authentication subkey, served by gpg-agent.
  personalKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5Os/AVZksrvTZ2+TNKUfCUpxlQUWYau97i0HyHV8Fn openpgp:0x41D6C915";
in {
  options.${namespace}.networking.ssh = {
    enable = mkEnableOption "Whether to enable OpenSSH";

    gpgAgent = mkOption {
      type = types.bool;
      default = config.${namespace}.security.gpg.enable;
      description = "Use gpg-agent as the SSH agent";
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      startAgent = !cfg.gpgAgent;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    environment.sessionVariables = mkIf cfg.gpgAgent {
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
    };

    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = lib.mkForce false;
        PubkeyAuthentication = lib.mkForce true;
        PubkeyAuthOptions = "none";
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
        LogLevel = "VERBOSE";
      };
    };

    users.users.${config.${namespace}.user.name}.openssh.authorizedKeys.keys = [personalKey];
    users.users.root.openssh.authorizedKeys.keys = [personalKey];
  };
}
