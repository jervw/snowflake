{
  config,
  lib,
  pkgs,
  namespace,
  user,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkOption enabled;

  cfg = config.${namespace}.programs.terminal.tools.fastfetch;
  jsonFormat = pkgs.formats.json {};
in {
  options.${namespace}.programs.terminal.tools.fastfetch = {
    enable = lib.mkEnableOption "Whether to enable fastfetch.";
    settings = mkOption {
      type = jsonFormat.type;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    # packages = mkIf (cfg.package != null) [cfg.package];

    ${namespace}.programs.terminal.tools.fastfetch = {
      settings = {
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

    xdg.configFile."fastfetch/config.jsonc" = mkIf (cfg.settings != {}) {
      source = jsonFormat.generate "config.jsonc" cfg.settings;
    };
  };
}
