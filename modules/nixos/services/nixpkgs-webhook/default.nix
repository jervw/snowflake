{
  config,
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.nixpkgs-webhook;
in {
  options.${namespace}.services.nixpkgs-webhook = {
    enable = mkEnableOption "Nixpkgs channel revision webhook service";

    channels = mkOption {
      type = lib.types.str;
      default = "nixos-unstable";
      description = "Comma-separated NixOS channels to monitor.";
    };

    updateInterval = mkOption {
      type = lib.types.ints.positive;
      default = 300;
      description = "Seconds between channel checks.";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.nixpkgs-webhook.file = "${inputs.self}/secrets/nixpkgs-webhook.age";

    systemd.services.nixpkgs-webhook = {
      description = "Nixpkgs channel revision webhook";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];

      serviceConfig = {
        ExecStart = lib.getExe inputs.self.packages.${pkgs.system}.nixpkgs-webhook;
        EnvironmentFile = config.age.secrets.nixpkgs-webhook.path;
        DynamicUser = true;
        StateDirectory = "nixpkgs-webhook";
        WorkingDirectory = "/var/lib/nixpkgs-webhook";
        Restart = "always";
        RestartSec = "10s";
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };

      environment = {
        NIX_CHANNELS = cfg.channels;
        UPDATE_INTERVAL = toString cfg.updateInterval;
      };
    };
  };
}
