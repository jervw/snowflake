{
  pkgs,
  config,
  inputs,
  ...
}: {
  services.caddy = {
    enable = true;
    package = inputs.cloudflare-caddy.packages."${pkgs.system}".cloudflare-caddy;
    extraConfig = ''
      (cloudflare) {
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
        }
    '';
  };
  age.secrets.cloudflare.file = "${self}/secrets/cloudflare.age";

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
}
