{
  lib,
  config,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.networking.tailscale;

  syncthingEnabled = config.home-manager.users.${user.name}.${namespace}.services.syncthing.enable or false;
in {
  options.${namespace}.networking.tailscale = with types; {
    enable = lib.mkEnableOption "Tailscale";
    extraUpFlags = mkOpt (listOf str) [] "Extra flags for starting Tailscale";
    forwarding = lib.mkEnableOption "IP forwarding for subnet routers and exit nodes";
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl = mkIf cfg.forwarding {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };

    networking = {
      firewall = {
        allowedUDPPorts = [config.services.tailscale.port];
        # tailscale0 is not trusted; services open their own ports on it.
        interfaces.${config.services.tailscale.interfaceName} = mkIf syncthingEnabled {
          allowedTCPPorts = [22000];
          allowedUDPPorts = [22000];
        };
        checkReversePath = "loose";
      };

      networkmanager.unmanaged = ["tailscale0"];
    };

    age.secrets.tailscale.file = "${inputs.self}/secrets/tailscale.age";
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
      extraSetFlags = ["--operator=${user.name}"];
      inherit (cfg) extraUpFlags;
      extraDaemonFlags = ["--no-logs-no-support"];
    };
  };
}
