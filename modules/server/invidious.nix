_: {
  services.caddy.virtualHosts."iv.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:3011
    import cloudflare
  '';

  services.invidious = {
    enable = true;
    port = 3011;
    settings = {
      registration_enabled = false;
      captcha_enabled = false;
      region = "FI";
      quality = "dash";
      quality_dash = "1440p";
      save_player_pos = true;
    };
  };
}
