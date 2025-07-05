{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkPackageOption mkIf mkMerge;
  cfg = config.${namespace}.services.beszel;
in {
  options.${namespace}.services.beszel = {
    enable = mkEnableOption "Enable beszel-agent service";
    package = mkPackageOption pkgs "beszel" {};

    # Beszel-Agent configuration
    settings = {
      port = mkOption {
        type = types.port;
        default = 45876;
        description = "SSH port on which the agent will listen.";
      };

      publicKey = mkOption {
        type = types.str;
        description = "SSH public key provided by the Beszel hub for authentication.";
        example = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...";
      };

      extraFilesystems = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of additional filesystems to monitor.";
        example = ["sdb"];
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open the agent port in the firewall.";
      };
    };

    # Beszel-Hub configuration
    server = {
      enable = mkEnableOption "Beszel hub server";

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "HTTP server listen address.";
      };

      port = mkOption {
        type = types.port;
        default = 8090;
        description = "HTTP server listen port.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open the configured port in the firewall.";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      systemd.services.beszel-agent = {
        description = "Beszel Agent Service";
        wantedBy = ["multi-user.target"];
        wants = ["network-online.target"];
        after = ["network-online.target"];

        environment =
          {
            PORT = toString cfg.settings.port;
            KEY = cfg.settings.publicKey;
          }
          // lib.optionalAttrs (cfg.settings.extraFilesystems != []) {
            EXTRA_FILESYSTEMS = lib.concatStringsSep "," cfg.settings.extraFilesystems;
          };

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/beszel-agent";
          Restart = "always";
          RestartSec = "5";
          Type = "simple";
        };
      };

      networking.firewall = mkIf cfg.settings.openFirewall {
        allowedTCPPorts = [cfg.settings.port];
      };
    })

    (mkIf cfg.server.enable {
      systemd.services.beszel-hub = {
        description = "Beszel Hub";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/beszel-hub serve --http ${cfg.server.host}:${toString cfg.server.port}";
          Restart = "always";
          RestartSec = "5";
          Type = "simple";
          User = "root";
        };
      };

      networking.firewall = mkIf cfg.server.openFirewall {
        allowedTCPPorts = [cfg.server.port];
      };
    })
  ];
}
