{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.${namespace}.networking.static-ip;

  # Detect if an address is IPv6
  isIPv6 = addr: builtins.match ".*:.*" addr != null;

  parseAddr = addr: let
    parts = lib.strings.splitString "/" addr;
    address = builtins.elemAt parts 0;
    cidr = builtins.elemAt parts 1;
  in {
    inherit address;
    prefixLength = lib.toInt cidr;
    isIPv6 = isIPv6 address;
  };

  # Parse all IPs and separate by version
  parsedIPs = map parseAddr (
    if builtins.isList cfg.ip
    then cfg.ip
    else [cfg.ip]
  );
  ipv4Addrs = builtins.filter (ip: !ip.isIPv6) parsedIPs;
  ipv6Addrs = builtins.filter (ip: ip.isIPv6) parsedIPs;

  # Parse gateways (support list or single string)
  gatewayList =
    if builtins.isList cfg.gateway
    then cfg.gateway
    else [cfg.gateway];
  ipv4Gateway = builtins.head (builtins.filter (gw: !isIPv6 gw) gatewayList);
  ipv6Gateway = let
    v6Gateways = builtins.filter (gw: isIPv6 gw) gatewayList;
  in
    if builtins.length v6Gateways > 0
    then builtins.head v6Gateways
    else null;
in {
  options.${namespace}.networking.static-ip = {
    enable = mkEnableOption "Enable static IP configuration (IPv4 and/or IPv6)";
    adapter = mkOption {
      type = types.str;
      description = "The name of the network adapter (e.g. enp4s0)";
    };
    ip = mkOption {
      type = types.either types.str (types.listOf types.str);
      description = ''
        Static IP address(es) with CIDR notation. Supports:
        - Single IPv4: "10.0.0.3/26"
        - Single IPv6: "2001:db8::1/64"
        - Dual-stack: ["10.0.0.3/26" "2001:db8::1/64"]
      '';
    };
    gateway = mkOption {
      type = types.either types.str (types.listOf types.str);
      description = ''
        Default gateway IP address(es). Supports:
        - Single IPv4: "10.0.0.1"
        - Single IPv6: "2001:db8::1"
        - Dual-stack: ["10.0.0.1" "2001:db8::1"]
      '';
    };
    dns = mkOption {
      type = types.listOf types.str;
      default = ["1.1.1.1" "8.8.8.8"];
      description = "List of DNS server IPs (IPv4 and/or IPv6)";
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
            address = ip.address;
            prefixLength = ip.prefixLength;
          })
          ipv4Addrs;

        ipv6.addresses =
          map (ip: {
            address = ip.address;
            prefixLength = ip.prefixLength;
          })
          ipv6Addrs;
      };

      defaultGateway = lib.mkIf (ipv4Gateway != null) {
        address = ipv4Gateway;
        interface = cfg.adapter;
      };

      defaultGateway6 = lib.mkIf (ipv6Gateway != null) {
        address = ipv6Gateway;
        interface = cfg.adapter;
      };

      nameservers = cfg.dns;
    };
  };
}
