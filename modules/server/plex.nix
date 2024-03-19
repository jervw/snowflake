{
  services.caddy.virtualHosts."plex.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:32400
    import cloudflare
  '';

  services.plex = {
    enable = true;
    openFirewall = true;
  };
}
