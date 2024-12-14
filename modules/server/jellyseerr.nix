{
  services.caddy.virtualHosts."seerr2.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:5056
    import cloudflare
  '';

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
    port = 5056;
  };
}
