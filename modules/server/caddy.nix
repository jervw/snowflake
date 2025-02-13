{
  pkgs,
  config,
  self,
  ...
}: {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e"];
      hash = "sha256-JVkUkDKdat4aALJHQCq1zorJivVCdyBT+7UhqTvaFLw=";
    };
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
