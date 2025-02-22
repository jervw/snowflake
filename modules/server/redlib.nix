{
  self,
  config,
  ...
}: {
  services.caddy.virtualHosts."redlib.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:8081
    import cloudflare
  '';

  services.redlib = {
    enable = true;
    port = 8081;
    settings = {
      REDLIB_DEFAULT_SHOW_NSFW = "on";
      REDLIB_DEFAULT_USE_HLS = "on";
      REDLIB_DEFAULT_HIDE_HLS_NOTIFICATION = "on";
    };
  };

  age.secrets.reddit.file = "${self}/secrets/reddit.age";

  # Used for REDLIB_DEFAULT_SUBSCRIPTIONS, I prefer to keep my subs private
  systemd.services.redlib = {
    serviceConfig = {
      EnvironmentFile = [config.age.secrets.reddit.path];
    };
  };
}
