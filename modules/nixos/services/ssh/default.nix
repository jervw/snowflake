{
  lib,
  config,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.ssh;
in {
  options.${namespace}.services.ssh = {
    enable = mkEnableOption "Whether to enable OpenSSH";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = lib.mkForce false;
        PubkeyAuthentication = lib.mkForce true;
        PubkeyAuthOptions = "none";
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
        LogLevel = "VERBOSE";
      };
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    users.users.${config.${namespace}.user.name}.openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
    users.users.root.openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
  };
}
