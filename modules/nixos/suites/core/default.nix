{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault mkForce mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.core;
in {
  options.${namespace}.suites.core = {
    enable = mkEnableOption "Whether to enable the Core suite.";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
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
    };

    networking.nftables.enable = mkForce true;

    snowflake = {
      programs = {
        terminal = {
          shells.fish = mkDefault enabled;
        };
      };
      security = {
        gpg = mkDefault enabled;
        sudo = mkDefault enabled;
        pam = mkDefault enabled;
      };

      services = {
        logind = mkDefault enabled;
        ssh = mkDefault enabled;
      };

      networking = {
        networkmanager = mkDefault enabled;
      };

      system = {
        systemd = mkDefault enabled;
        locale = mkDefault enabled;
        time = mkDefault enabled;
      };
    };
  };
}
