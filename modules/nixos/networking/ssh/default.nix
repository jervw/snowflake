{
  lib,
  config,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.${namespace}.networking.ssh = {
    enable = mkEnableOption "Whether to enable OpenSSH";
  };

  # TODO: Gate options and add optional GPG-agent integration, remove host keys and retire ssh-keys flake input

  config = {
    programs.ssh = {
      startAgent = false; # Don't start, we're using GPG-agent

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

    users.users.${config.${namespace}.user.name}.openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
    users.users.root.openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
  };
}
