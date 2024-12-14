_: {
  services.caddy.virtualHosts."watch.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:8096
    import cloudflare
  '';

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
