{
  services.caddy.virtualHosts."home.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:5678
    import cloudflare
  '';

  services.glance = {
    enable = true;
    openFirewall = true;
    settings = {
      pages = [
        {
          name = "Startpage";
          width = "slim";
          hideDesktopNavigation = true;
          centerVertically = true;
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  search-engine = "https://kagi.com/search?q={QUERY}";
                  autofocus = true;
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "General";
                      links = [
                        {
                          title = "Proton Mail";
                          url = "https://mail.proton.me/u/0/";
                        }
                        {
                          title = "Github";
                          url = "https://github.com/";
                        }
                      ];
                    }
                    {
                      title = "Entertainment";
                      links = [
                        {
                          title = "YouTube";
                          url = "https://www.youtube.com/";
                        }
                      ];
                    }
                    {
                      title = "Social";
                      links = [
                        {
                          title = "Reddit";
                          url = "https://www.redlib.jervw.dev/";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
      server = {
        host = "0.0.0.0";
        port = 5678;
      };
    };
  };
}
