{pkgs, ...}: {
  services.caddy.virtualHosts."redlib.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:8081
    import cloudflare
  '';

  services.redlib = {
    enable = true;
    openFirewall = true;
    port = 8081;
  };
}
