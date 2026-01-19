# Static IPs are simple. Until they aren't.
{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.${namespace}.networking.static-ip;

  parseAddr = addr: let
    parts = lib.strings.splitString "/" addr;
    address = builtins.elemAt parts 0;
    cidr = builtins.elemAt parts 1;
  in {
    inherit address;
    prefixLength = lib.toInt cidr;
  };

  parsedIPs = map parseAddr (
    if builtins.isList cfg.ip
    then cfg.ip
    else [cfg.ip]
  );

  # Parse gateway (support list or single string)
  gateway =
    if builtins.isList cfg.gateway
    then builtins.head cfg.gateway
    else cfg.gateway;
in {
  options.${namespace}.networking.static-ip = {
    enable = mkEnableOption "Enable static IP configuration (IPv4)";
    adapter = mkOption {
      type = types.str;
      description = "The name of the network adapter (e.g. enp4s0)";
    };
    ip = mkOption {
      type = types.either types.str (types.listOf types.str);
      description = ''
        Static IP address(es) with CIDR notation.
        Example: "10.0.0.3/26" or ["10.0.0.3/26" "10.0.0.4/26"]
      '';
    };
    gateway = mkOption {
      type = types.either types.str (types.listOf types.str);
      description = ''
        Default gateway IP address.
        Example: "10.0.0.1"
      '';
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
      hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

      interfaces.${cfg.adapter} = {
        ipv4.addresses =
          map (ip: {
            inherit (ip) address;
            inherit (ip) prefixLength;
          })
          parsedIPs;
      };

      defaultGateway = {
        address = gateway;
        interface = cfg.adapter;
      };

      nameservers = cfg.dns;
    };
  };
}
