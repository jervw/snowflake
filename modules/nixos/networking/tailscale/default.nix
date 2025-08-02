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
in {
  options.${namespace}.networking.tailscale = with types; {
    enable = lib.mkEnableOption "Tailscale";
    extraUpFlags = mkOpt (listOf str) [] "Extra flags for starting Tailscale";
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      # Enable IP forwarding
      # required for Wireguard & Tailscale/Headscale subnet feature
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };

    networking = {
      firewall = {
        allowedUDPPorts = [config.services.tailscale.port];
        allowedTCPPorts = [];
        trustedInterfaces = [config.services.tailscale.interfaceName];
        checkReversePath = "loose";
      };

      networkmanager.unmanaged = ["tailscale0"];
    };

    age.secrets.tailscale.file = "${inputs.self}/secrets/tailscale.age";
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
      extraSetFlags = ["--operator=${user.name}"];
      extraUpFlags = cfg.extraUpFlags;
      extraDaemonFlags = ["--no-logs-no-support"];
    };
  };
}
