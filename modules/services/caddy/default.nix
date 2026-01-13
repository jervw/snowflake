{
  config,
  lib,
  namespace,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.caddy;
in {
  options.${namespace}.services.caddy = {
    enable = mkEnableOption "Enable Caddy service";
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
        hash = "sha256-AcWko5513hO8I0lvbCLqVbM1eWegAhoM0J0qXoWL/vI=";
      };
      extraConfig = ''
        (cloudflare) {
          tls {
            dns cloudflare {env.CF_API_TOKEN}
          }
        }
      '';
    };

    age.secrets.cloudflare = {
      file = "${inputs.self}/secrets/cloudflare.age";
      mode = "0400";
      owner = "caddy";
      group = "caddy";
    };

    systemd.services.caddy = {
      after = ["agenix.service"];
      serviceConfig = {
        EnvironmentFile = config.age.secrets.cloudflare.path;
      };
    };
  };
}
