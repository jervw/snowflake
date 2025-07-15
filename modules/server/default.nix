_: {
  services.caddy.virtualHosts = {
    "hoarder.jervw.dev".extraConfig = ''
      reverse_proxy http://127.0.0.1:3020
      import cloudflare
    '';
    "profilarr.jervw.dev".extraConfig = ''
      reverse_proxy http://127.0.0.1:6868
      import cloudflare
    '';
    "speedtest.jervw.dev".extraConfig = ''
      reverse_proxy http://127.0.0.1:8095
      import cloudflare
    '';
  };
}
