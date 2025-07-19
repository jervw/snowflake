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
        hash = "sha256-2D7dnG50CwtCho+U+iHmSj2w14zllQXPjmTHr6lJZ/A=";
      };
      extraConfig = ''
        (cloudflare) {
            tls {
              dns cloudflare {env.CLOUDFLARE_API_TOKEN}
            }
          }
      '';
    };

    age.secrets.cloudflare.file = "${inputs.self}/secrets/cloudflare.age";

    systemd.services.caddy.serviceConfig = {
      LoadCredential = "CLOUDFLARE_API_TOKEN:${config.age.secrets.cloudflare.path}";
      EnvironmentFile = "-%t/caddy/secrets.env";
      RuntimeDirectory = "caddy";
      ExecStartPre = [
        ((pkgs.writeShellApplication {
            name = "caddy-secrets";
            text = "echo \"CLOUDFLARE_API_TOKEN=\\\"$(<\"$CREDENTIALS_DIRECTORY/CLOUDFLARE_API_TOKEN\")\\\"\" > \"$RUNTIME_DIRECTORY/secrets.env\"";
          })
          + "/bin/caddy-secrets")
      ];
      AmbientCapabilities = "cap_net_bind_service";
      CapabilityBoundingSet = "cap_net_bind_service";
    };
  };
}
