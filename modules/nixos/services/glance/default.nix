{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.glance;
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
        openFirewall = true;
        settings = {
          server = {
            host = "0.0.0.0";
            port = cfg.port;
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
                            {
                              title = "Plex";
                              icon = "sh:plex";
                              url = "https://plex.jervw.dev";
                            }
                            {
                              title = "Immich";
                              icon = "sh:immich";
                              url = "https://media.jervw.dev";
                            }
                            {
                              title = "Audiobookshelf";
                              icon = "sh:audiobookshelf";
                              url = "https://shelf.jervw.dev";
                            }
                            {
                              title = "Karakeep";
                              icon = "sh:karakeep";
                              url = "https://save.jervw.dev";
                            }
                          ];
                        }

                        {
                          title = "Media Automation";
                          links = [
                            {
                              title = "Jellyfin";
                              icon = "sh:jellyfin";
                              url = "https://watch.jervw.dev";
                            }
                            {
                              title = "Sonarr";
                              icon = "sh:sonarr";
                              url = "https://sonarr.jervw.dev";
                            }
                            {
                              title = "Radarr";
                              icon = "sh:radarr";
                              url = "https://radarr.jervw.dev";
                            }
                            {
                              title = "Bazarr";
                              icon = "sh:bazarr";
                              url = "https://bazarr.jervw.dev";
                            }
                            {
                              title = "Prowlarr";
                              icon = "sh:prowlarr";
                              url = "https://prowlarr.jervw.dev";
                            }
                          ];
                        }

                        {
                          title = "Monitoring & Networking";
                          links = [
                            {
                              title = "Grafana";
                              icon = "sh:grafana";
                              url = "https://monitor.jervw.dev";
                            }
                            {
                              title = "Speedtest Tracker";
                              icon = "sh:speedtest-tracker";
                              url = "https://speedtest.jervw.dev";
                            }
                            {
                              title = "Tautulli";
                              icon = "sh:tautulli";
                              url = "https://tautulli.jervw.dev";
                            }
                            {
                              title = "AdGuard Home";
                              icon = "sh:adguard-home";
                              url = "https://dns.jervw.dev";
                            }
                          ];
                        }
                        {
                          title = "Misc";
                          links = [
                            {
                              title = "qBittorrent";
                              icon = "sh:qbittorrent";
                              url = "https://dl.jervw.dev";
                            }
                            {
                              title = "Profilarr";
                              icon = "di:profilarr";
                              url = "https://profilarr.jervw.dev";
                            }
                            {
                              title = "Redlib";
                              icon = "sh:reddit";
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
                      autofocus = false;
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

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
      '';
    };
  };
}
