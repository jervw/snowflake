{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep mapAttrsToList mkBefore mkEnableOption mkIf mkMerge mkOption;
  cfg = config.${namespace}.services.beszel;
in {
  options.${namespace}.services.beszel = {
    hub = {
      enable = mkEnableOption "Enable the Beszel monitoring hub";
      host = mkOption {
        type = lib.types.str;
        default = "monitoring.jervw.dev";
        description = "Reverse proxy host name for the Beszel hub";
      };
      port = mkOption {
        type = lib.types.port;
        default = 8090;
        description = "Local port for the Beszel hub";
      };
    };

    agent = {
      enable = mkEnableOption "Enable the Beszel monitoring agent";
      port = mkOption {
        type = lib.types.port;
        default = 45876;
        description = "Port for the Beszel agent";
      };
      extraFilesystems = mkOption {
        type = lib.types.attrsOf (lib.types.nullOr lib.types.str);
        default = {};
        example = {
          "/mnt/extra" = null;
          "/mnt/storage" = "Storage";
        };
        description = ''
          Additional filesystems for the Beszel agent to monitor. Map each
          filesystem path to a custom chart name, or use null to keep the
          default name.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.hub.enable {
      services = {
        beszel.hub = {
          enable = true;
          host = "127.0.0.1";
          inherit (cfg.hub) port;
          environment = {
            APP_URL = "https://${cfg.hub.host}";
            DISABLE_PASSWORD_AUTH = "true"; # For OIDC
          };
        };

        caddy.virtualHosts."${cfg.hub.host}".extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString cfg.hub.port}
          import cloudflare
        '';
      };

      age.secrets.beszel-hub-key.file = "${inputs.self}/secrets/beszel-hub-key.age";

      systemd.services.beszel-hub = {
        after = ["agenix.service"];
        serviceConfig = {
          LoadCredential = "id_ed25519:${config.age.secrets.beszel-hub-key.path}";
          ExecStartPre = mkBefore [
            "${pkgs.coreutils}/bin/install -D -m 0600 %d/id_ed25519 ${config.services.beszel.hub.dataDir}/beszel_data/id_ed25519"
          ];
        };
      };
    })

    (mkIf cfg.agent.enable {
      services.beszel.agent = {
        enable = true;
        environment = {
          LISTEN = toString cfg.agent.port;
        } // lib.optionalAttrs (cfg.agent.extraFilesystems != {}) {
          EXTRA_FILESYSTEMS = concatStringsSep "," (mapAttrsToList (
            path: name:
              if name == null
              then path
              else "${path}__${name}"
          ) cfg.agent.extraFilesystems);
        };
        environmentFile = config.age.secrets.beszel-agent.path;
        openFirewall = false;
        smartmon = {
          enable = true;
          # TODO: Add deviceAllow if needed
        };
        extraPath = lib.optionals config.hardware.nvidia.enabled [
          config.hardware.nvidia.package
        ];
      };

      age.secrets.beszel-agent = {
        file = "${inputs.self}/secrets/beszel-agent.age";
        mode = "0400";
        owner = "beszel-agent";
        group = "beszel-agent";
      };

      systemd.services.beszel-agent.after = ["agenix.service"];
    })
  ];
}
