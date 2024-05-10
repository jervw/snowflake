{
  services.caddy.virtualHosts."media.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:2283
    import cloudflare
  '';
}
