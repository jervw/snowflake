{
  services.caddy.virtualHosts."shelf.jervw.dev".extraConfig = ''
    reverse_proxy http://0.0.0.0:8000
    import cloudflare
  '';

  services.audiobookshelf = {
    enable = true;
  };
}
