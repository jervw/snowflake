_: {
  services.caddy.virtualHosts."jellyfin.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:8096
    import cloudflare
  '';

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
