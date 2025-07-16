{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault mkEnableOption;
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

        # archiving
        unar
        zip
        unzip
      ];
    };

    snowflake = {
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

    programs.fish = {
      enable = true;
    };
  };
}
