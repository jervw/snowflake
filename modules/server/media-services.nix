{
  services.caddy = {
    virtualHosts."radarr.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:7878
      import cloudflare
    '';
    virtualHosts."sonarr.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:8989
      import cloudflare
    '';
    virtualHosts."prowlarr.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:9696
      import cloudflare
    '';
    virtualHosts."bazarr.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:6767
      import cloudflare
    '';
  };

  services = {
    radarr = {
      enable = true;
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      openFirewall = true;
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
    bazarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
