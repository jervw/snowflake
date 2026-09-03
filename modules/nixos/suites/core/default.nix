{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault mkForce mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.core;
  meta = inputs.self.snowfall.config.meta;
in {
  options.${namespace}.suites.core = {
    enable = mkEnableOption "Whether to enable the Core suite.";
  };

  config = mkIf cfg.enable {
    hardware.enableRedistributableFirmware = true;

    system.nixos = {
      distroName = meta.title;
      distroId = meta.name;
      version = "";
    };

    environment.systemPackages = with pkgs; [
      git
      curl
      killall
      lazyjournal
      python3
      aria2
      file
      jq
      dua

      # archiving
      unar
      zip
      unzip
    ];

    networking.nftables.enable = mkForce true;

    snowflake = {
      programs = {
        shells.fish = mkDefault enabled;
      };
      security = {
        gpg = mkDefault enabled;
        sudo = mkDefault enabled;
        pam = mkDefault enabled;
      };

      services = {
        beszel.agent = mkDefault enabled;
      };

      networking = {
        networkmanager = mkDefault enabled;
        ssh = mkDefault enabled;
      };

      system = {
        systemd = mkDefault enabled;
        locale = mkDefault enabled;
        logind = mkDefault enabled;
        time = mkDefault enabled;
      };
    };
  };
}
