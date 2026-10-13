{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) concatStringsSep mkEnableOption mkIf mkOption optionalString types;

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

    lanSubnets = mkOption {
      type = types.listOf types.str;
      default = ["10.0.0.0/26"];
      description = "IPv4 subnets allowed to reach SSH outside of Tailscale";
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
      # Reachable via tailscale0 (trusted) and lanSubnets only.
      openFirewall = false;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = lib.mkForce false;
        PubkeyAuthentication = lib.mkForce true;
        PubkeyAuthOptions = "none";
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        LogLevel = "VERBOSE";
      };
    };

    networking.firewall.extraInputRules = optionalString (cfg.lanSubnets != []) ''
      ip saddr { ${concatStringsSep ", " cfg.lanSubnets} } tcp dport { ${concatStringsSep ", " (map toString config.services.openssh.ports)} } accept
    '';

    networking.firewall.interfaces = mkIf config.services.tailscale.enable {
      ${config.services.tailscale.interfaceName} = {allowedTCPPorts = config.services.openssh.ports;};
    };

    users.users.${config.${namespace}.user.name}.openssh.authorizedKeys.keys = [personalKey];
  };
}
