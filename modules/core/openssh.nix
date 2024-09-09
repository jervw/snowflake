{
  inputs,
  lib,
  user,
  ...
}: {
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

  users.users.${user}.openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
  users.users.root.openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
}
