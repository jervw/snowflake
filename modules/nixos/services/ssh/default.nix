{
  lib,
  config,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.services.ssh = {
    enable = mkEnableOption "Whether to enable OpenSSH";
  };

  config = {
    programs.ssh = {
      startAgent = false; # Don't start, we're using gpg-agent

      # Make regular SSH keys required for Agenix available
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    # Set SSH_AUTH_SOCK to use gpg-agent
    environment.sessionVariables = {
      SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
    };

    services.openssh = {
      # FIXME: For now forcefully enable OpenSSH because Agenix requires it to pass `nix flake check` before having any systems configured unless age.identityPaths is set
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
