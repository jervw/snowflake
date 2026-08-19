{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.glance;

  # Helper functions to reduce length
  mkBookmark = title: icon: url: {inherit title icon url;};
  mkGroup = widgets: {
    type = "group";
    inherit widgets;
  };
  mkReddit = subreddit: {
    type = "reddit";
    show-thumbnails = true;
    inherit subreddit;
  };
  mkRss = title: url: {
    type = "rss";
    inherit title;
    limit = 10;
    cache = "1h";
    feeds = [{inherit url;}];
  };
in {
  options.${namespace}.services.glance = {
    enable = mkEnableOption "Enable Glance service";
    host = mkOption {
      type = lib.types.str;
      default = "home.jervw.dev";
      description = "Reverse proxy host name for the Glance service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 5678;
    };
  };

  config = mkIf cfg.enable {
    services = {
      glance = {
        enable = true;
        settings = {
          server = {
            host = "127.0.0.1";
            inherit (cfg) port;
            proxied = true;
          };
          branding = {
            logo-text = "DASH";
            favicon-url = "https://jervw.dev/favicon-7a187dc8cc543a31.png";
            hide-footer = true;
          };
          pages = [
            {
              name = "Home";
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "bookmarks";
                      groups = [
                        {
                          title = "Media Servers";
                          links = [
                            (mkBookmark "Plex" "sh:plex" "https://plex.jervw.dev")
                            (mkBookmark "Immich" "sh:immich" "https://media.jervw.dev")
                            (mkBookmark "Navidrome" "sh:navidrome" "https://music.jervw.dev")
                            (mkBookmark "Audiobookshelf" "sh:audiobookshelf" "https://shelf.jervw.dev")
                            (mkBookmark "Karakeep" "sh:karakeep" "https://save.jervw.dev")
                          ];
                        }

                        {
                          title = "Media Automation";
                          links = [
                            (mkBookmark "Seerr" "sh:jellyseerr" "https://seerr.jervw.dev")
                            (mkBookmark "Sonarr" "sh:sonarr" "https://sonarr.jervw.dev")
                            (mkBookmark "Radarr" "sh:radarr" "https://radarr.jervw.dev")
                            (mkBookmark "Bazarr" "sh:bazarr" "https://bazarr.jervw.dev")
                            (mkBookmark "Prowlarr" "sh:prowlarr" "https://prowlarr.jervw.dev")
                          ];
                        }

                        {
                          title = "Monitoring & Networking";
                          links = [
                            (mkBookmark "Tautulli" "sh:tautulli" "https://tautulli.jervw.dev")
                            (mkBookmark "AdGuard Home" "sh:adguard-home" "https://dns.jervw.dev")
                          ];
                        }
                        {
                          title = "Misc";
                          links = [
                            (mkBookmark "qBittorrent" "sh:qbittorrent" "https://dl.jervw.dev")
                            (mkBookmark "Wallos" "sh:wallos" "https://wallos.jervw.dev")
                          ];
                        }
                        {
                          title = "Books & Documents";
                          links = [
                            (mkBookmark "Calibre-Web" "sh:calibre-web" "https://calibre.jervw.dev")
                            (mkBookmark "Paperless-ngx" "sh:paperless-ngx" "https://paperless.jervw.dev")
                          ];
                        }
                        {
                          title = "Auth";
                          links = [
                            (mkBookmark "Pocket ID" "sh:pocket-id" "https://id.jervw.dev")
                            (mkBookmark "Tinyauth" "sh:tinyauth" "https://auth.jervw.dev")
                          ];
                        }
                      ];
                    }
                    {
                      type = "twitch-top-games";
                      exclude = [
                        "slots"
                        "always-on"
                        "crypto"
                        "im-only-sleeping"
                      ];
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "search";
                      search-engine = "https://kagi.com/search?q={QUERY}";
                      autofocus = false;
                    }
                    (mkGroup [
                      (mkReddit "worldnews")
                      (mkReddit "linux_gaming")
                      (mkReddit "NixOS")
                      (mkReddit "selfhosted")
                    ])
                    {
                      type = "videos";
                      channels = [
                        "UCUahpYHkcXv2QqfdSrJT7GA" # Elmo
                        "UCgCaKhRfd0nmBSlRZKnP2yA" # Paistajat
                        "UCZXW8E1__d5tZb-wLFOt8TQ" # Bog
                        "UCXuqSBlHAE6Xw-yeJA0Tunw" # LTT
                        "UCb14ea61ASi7gq-wVviSJfg" # Viktor
                        "UCB2wtYpfbCpYDc5TeTwuqFA" # Will
                      ];
                    }
                    (mkGroup [
                      {
                        type = "hacker-news";
                        collapse-after = 10;
                      }
                      {
                        type = "lobsters";
                        collapse-after = 10;
                      }
                    ])
                  ];
                }
                {
                  size = "small";
                  widgets = [
                    {
                      type = "weather";
                      location = "Espoo, Finland";
                    }
                    (mkGroup [
                      (mkRss "Yle" "https://yle.fi/rss/uutiset/paauutiset")
                      (mkRss "Phoronix" "https://www.phoronix.com/rss.php")
                    ])
                    {
                      type = "custom-api";
                      title = "Bible Verse";
                      cache = "24h";
                      url = "https://bible-api.com/data/web/random";
                      template = ''
                        <p class="size-h2 color-highlight">{{ .JSON.String "random_verse.book" }} {{ .JSON.String "random_verse.chapter" }}:{{ .JSON.String "random_verse.verse" }}</p>
                        <p class="size-h4 color-paragraph">{{ .JSON.String "random_verse.text" }}</p>
                      '';
                    }
                  ];
                }
              ];
            }
          ];
        };
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
        import cloudflare
        import tinyauth
      '';
    };
  };
}
