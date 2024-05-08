{inputs, ...}: {
  home.file."firefox-gnome-theme" = {
    target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
    source = inputs.firefox-gnome-theme;
  };
  programs.firefox = {
    enable = true;

    profiles.default = {
      settings = {
        "browser.send_pings" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "dom.event.clipboardevents.enabled" = true;
        "media.navigator.enabled" = false;
        "network.cookie.cookieBehavior" = 1;
        "network.http.referer.XOriginPolicy" = 2;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "beacon.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "network.IDN_show_punycode" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "app.shield.optoutstudies.enabled" = false;
        "dom.security.https_only_mode_ever_enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "geo.enabled" = false;

        # Allow syncing browser config to Firefox Sync
        "services.sync.prefs.dangerously_allow_arbitrary" = true;

        # Disable telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "";

        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;

        # Disable JS in PDFs
        "pdfjs.enableScripting" = false;

        # Harden SSL
        "security.ssl.require_safe_negotiation" = true;

        # Extra
        "browser.urlbar.trimHttps" = true;
        "browser.tabs.tabmanager.enabled" = false;
        "browser.fullscreen.autohide" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.uidensity" = 1;
        "dom.confirm_repost.testing.always_accept" = true;
        "reader.parse-on-load.enabled" = false;

        "privacy.firstparty.isolate" = true;
        "network.http.sendRefererHeader" = 0;

        # Gnome theme
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "gnomeTheme.hideSingleTab" = true;
        "gnomeTheme.bookmarksToolbarUnderTabs" = true;
        "gnomeTheme.normalWidthTabs" = false;
        "gnomeTheme.tabsAsHeaderbar" = false;
      };
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
    };
  };
}
