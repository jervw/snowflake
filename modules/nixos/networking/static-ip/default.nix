{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.${namespace}.networking.static-ip;
in {
  options.${namespace}.networking.static-ip = {
    enable = mkEnableOption "Enable static IP configuration";

    adapter = mkOption {
      type = types.str;
      description = "The name of the network adapter (e.g. enp4s0)";
    };

    addresses = mkOption {
      type = types.listOf types.str;
      description = "Static IP addresses with CIDR notation, e.g., [ '10.0.0.3/26', 'fd00::1/64' ]";
    };

    gateways = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of default gateway IP addresses";
    };

    dns = mkOption {
      type = types.listOf types.str;
      default = ["1.1.1.1" "8.8.8.8"];
      description = "List of DNS server IPs";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = lib.mkForce false;
      useDHCP = lib.mkForce false;
    };

    systemd.network = {
      enable = true;
      networks."10-${cfg.adapter}" = {
        matchConfig.Name = cfg.adapter;
        address = cfg.addresses;
        gateway = cfg.gateways;
        dns = cfg.dns;
      };
    };
  };
}
