{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.${namespace}.networking.static-ip;

  parsedAddr = let
    parts = lib.strings.splitString "/" cfg.ip;
    address = builtins.elemAt parts 0;
    cidr = builtins.elemAt parts 1;
  in {
    inherit address;
    prefixLength = lib.toInt cidr;
  };
in {
  options.${namespace}.networking.static-ip = {
    enable = mkEnableOption "Enable static IPv4 configuration";
    adapter = mkOption {
      type = types.str;
      description = "The name of the network adapter (e.g. enp4s0)";
    };
    ip = mkOption {
      type = types.str;
      description = "Static IP address with CIDR notation, e.g. 10.0.0.3/26";
    };
    gateway = mkOption {
      type = types.str;
      description = "Default gateway IP address";
    };
    dns = mkOption {
      type = types.listOf types.str;
      default = ["1.1.1.1" "8.8.8.8"];
      description = "List of DNS server IPs";
    };
  };

  # TODO Add IPv6 support

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = lib.mkForce false;
      useDHCP = lib.mkForce false;

      hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

      interfaces.${cfg.adapter}.ipv4.addresses = [
        {
          address = parsedAddr.address;
          prefixLength = parsedAddr.prefixLength;
        }
      ];

      defaultGateway = {
        address = cfg.gateway;
        interface = cfg.adapter;
      };

      nameservers = cfg.dns;
    };
  };
}
