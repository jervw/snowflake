{
  services.caddy.virtualHosts."tautulli.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:8181
    import cloudflare
  '';

  services.tautulli = {
    enable = true;
  };
}
