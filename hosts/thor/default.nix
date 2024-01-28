{
  pkgs,
  lib,
  ...
}: let
  # The wired external interface
  eth-interface = "enp4s0";
  wg-interface = "wg0";
in {
  imports = [
    ./hardware-configuration.nix
    ./services
    ../../modules/core
    ../../modules/virtualisation
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["zfs"];
    zfs = {
      forceImportRoot = false;
      extraPools = ["zpool"];
    };
  };

  networking = {
    hostName = "thor";
    hostId = "7f6f07cd";
    firewall.enable = false; # TODO enable later

    nat = {
      enable = true;
      externalInterface = eth-interface;
      internalInterfaces = [wg-interface];
    };

    interfaces = {
      ${eth-interface}.ipv4.addresses = [
        {
          address = "192.168.50.140";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.50.1";
      interface = eth-interface;
    };
    nameservers = ["127.0.0.1" "1.1.1.1"];

    # Wireguard VPN
    wireguard.interfaces = {
      "${wg-interface}" = {
        ips = ["10.10.0.1/24"];
        listenPort = 51820;
        privateKeyFile = "/root/wg-private";

        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o ${eth-interface} -j MASQUERADE
        '';

        # Undo the above
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.10.0.0/24 -o ${eth-interface} -j MASQUERADE
        '';

        peers = [
          {
            # Phone
            publicKey = "jgG2UZzaQCmpu5KpLUtC0UMyS54nktw17F9ht4tzR0k=";
            allowedIPs = ["10.10.0.2/32"];
          }
          # Laptop
          {
            publicKey = "KzPFwWqmtVY1eoaBCmSpI7scGK69g1uNyGInwYwT6Rs=";
            allowedIPs = ["10.10.0.3/32"];
          }
        ];
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
}
