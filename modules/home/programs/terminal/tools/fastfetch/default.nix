{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.tools.fastfetch;
in {
  options.${namespace}.programs.terminal.tools.fastfetch = {
    enable = lib.mkEnableOption "Enable fastfetch";
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
          padding = {
            top = 1;
            right = 3;
          };
        };

        display = {
          separator = "";
          key.width = 12;
        };

        modules = [
          {
            key = " user";
            type = "title";
            format = "{1}@{2}";
            keyColor = "31";
          }
          {
            key = "󰅐 up";
            type = "uptime";
            keyColor = "33";
          }
          {
            key = " distro";
            type = "os";
            keyColor = "34";
            format = "{3}";
          }
          {
            key = " pkgs";
            type = "packages";
            keyColor = "32";
          }
          {
            key = " kernel";
            type = "kernel";
            keyColor = "35";
          }
          {
            key = "󰇄 desktop";
            type = "de";
            keyColor = "36";
          }
          {
            key = " term";
            type = "terminal";
            keyColor = "31";
            format = "{1}";
          }
          {
            key = " shell";
            type = "shell";
            keyColor = "33";
            format = "{1}";
          }
          {
            key = "󰍛 cpu";
            type = "cpu";
            showPeCoreCount = true;
            keyColor = "34";
          }
          {
            key = " memory";
            type = "memory";
            keyColor = "32";
          }
        ];
      };
    };
  };
}
