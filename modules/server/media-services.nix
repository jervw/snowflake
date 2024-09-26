{
  services.caddy.virtualHosts = {
    "radarr.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:7878
      import cloudflare
    '';
    "sonarr.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:8989
      import cloudflare
    '';
    "prowlarr.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:9696
      import cloudflare
    '';
    "bazarr.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:6767
      import cloudflare
    '';
  };

  services = {
    radarr.enable = true;
    sonarr.enable = true;
    prowlarr.enable = true;
    bazarr.enable = true;
  };
}
