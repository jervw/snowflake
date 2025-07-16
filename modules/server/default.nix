_: {
  services.caddy.virtualHosts = {
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
