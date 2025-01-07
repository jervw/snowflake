{
  services.caddy.virtualHosts."home.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:5678
    import cloudflare
  '';

  services.glance = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 5678;
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
                  type = "calendar";
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      links = [
                        {
                          title = "Plex";
                          icon = "si:plex";
                          url = "https://plex.jervw.dev";
                        }
                        {
                          title = "Jellyfin";
                          icon = "si:jellyfin";
                          url = "https://watch.jervw.dev";
                        }
                        {
                          title = "Immich";
                          icon = "si:immich";
                          url = "https://media.jervw.dev";
                        }
                        {
                          title = "Audiobookshelf";
                          icon = "si:audiobookshelf";
                          url = "https://shelf.jervw.dev";
                        }
                        {
                          title = "Sonarr";
                          icon = "si:sonarr";
                          url = "https://sonarr.jervw.dev";
                        }
                        {
                          title = "Radarr";
                          icon = "si:radarr";
                          url = "https://radarr.jervw.dev";
                        }
                        {
                          title = "qBittorrent";
                          icon = "si:qbittorrent";
                          url = "https://dl.jervw.dev";
                        }
                        {
                          title = "AdGuard Home";
                          icon = "si:adguard";
                          url = "https://dns.jervw.dev";
                        }
                        {
                          title = "Redlib";
                          icon = "si:reddit";
                          url = "https://redlib.jervw.dev";
                        }
                      ];
                    }
                  ];
                }
                {
                  type = "twitch-channels";
                  collapse-after = 10;
                  channels = [
                    "xqc"
                    "theprimeagen"
                    "loltyler1"
                    "sodapoppin"
                    "erobb221"
                    "caseoh_"
                    "Mizkif"
                    "Emiru"
                    "KaiCenat"
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
                  autofocus = true;
                }
                {
                  type = "group";
                  widgets = [
                    {
                      type = "reddit";
                      show-thumbnails = true;
                      subreddit = "worldnews";
                    }
                    {
                      type = "reddit";
                      show-thumbnails = true;
                      subreddit = "linux";
                    }
                    {
                      type = "reddit";
                      show-thumbnails = true;
                      subreddit = "NixOS";
                    }
                  ];
                }
                {
                  type = "rss";
                  style = "horizontal-cards";
                  limit = 10;
                  collapse-after = 10;
                  cache = "1h";
                  feeds = [
                    {
                      url = "https://feeds.yle.fi/uutiset/v1/majorHeadlines/YLE_UUTISET.rss";
                      title = "Yle";
                    }
                  ];
                }
                {
                  type = "hacker-news";
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "Espoo, Finland";
                }
                {
                  type = "rss";
                  limit = 10;
                  cache = "1h";
                  feeds = [
                    {
                      url = "https://www.phoronix.com/rss.php";
                      title = "Phoronix";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
