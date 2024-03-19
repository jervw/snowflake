{
  services.caddy.virtualHosts."dl.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:8080
    import cloudflare
  '';
}
