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
        hash = "sha256-ijDzBvNhN6kVRNkjbLMHRh1K8qP7kLCiirQJLwkzrCc=";
      };
      extraConfig = ''
        (cloudflare) {
          tls {
            dns cloudflare {env.CF_API_TOKEN}
          }
        }
        (tinyauth) {
          forward_auth http://127.0.0.1:3333 {
            uri /api/auth/caddy

            copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
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

    networking.firewall.interfaces = mkIf config.services.tailscale.enable {
      ${config.services.tailscale.interfaceName} = {allowedTCPPorts = [443];};
    };

    systemd.services.caddy = {
      after = ["agenix.service"];
      serviceConfig = {
        EnvironmentFile = config.age.secrets.cloudflare.path;
      };
    };
  };
}
