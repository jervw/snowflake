{ pkgs, ...}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;

    profiles.jervw = {
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

        # Disable telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "";

        # Disable Pocket
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "extensions.pocket.enabled" = false;

        # Disable prefetching
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;

        # Disable JS in PDFs
        "pdfjs.enableScripting" = false;

        # Harden SSL 
        "security.ssl.require_safe_negotiation" = true;

        # Extra
        "browser.fixup.domainsuffixwhitelist.asgard" = true;
        "browser.tabs.tabmanager.enabled" = false;
        "browser.fullscreen.autohide" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.uidensity" = 1;
        
        "privacy.firstparty.isolate" = true;
        "network.http.sendRefererHeader" = 0;
    };
    userChrome = "
        * { 
            box-shadow: none !important;
            border: 0px solid !important;
        }

        #tabbrowser-tabs {
            --user-tab-rounding: 8px;
        }

        .tab-background {
            border-radius: var(--user-tab-rounding) var(--user-tab-rounding) 0px 0px !important; /* Connected */
            margin-block: 1px 0 !important; /* Connected */
        }
        #scrollbutton-up, #scrollbutton-down { /* 6/10/2021 */
            border-top-width: 1px !important;
            border-bottom-width: 0 !important;
        }

        .tab-background:is([selected], [multiselected]):-moz-lwtheme {
            --lwt-tabs-border-color: rgba(0, 0, 0, 0.5) !important;
            border-bottom-color: transparent !important;
        }
        [brighttext='true'] .tab-background:is([selected], [multiselected]):-moz-lwtheme {
            --lwt-tabs-border-color: rgba(255, 255, 255, 0.5) !important;
            border-bottom-color: transparent !important;
        }

        /* Container color bar visibility */
        .tabbrowser-tab[usercontextid] > .tab-stack > .tab-background > .tab-context-line {
            margin: 0px max(calc(var(--user-tab-rounding) - 3px), 0px) !important;
        }

        #TabsToolbar, #tabbrowser-tabs {
            --tab-min-height: 29px !important;
        }
        #main-window[sizemode='true'] #toolbar-menubar[autohide='true'] + #TabsToolbar, 
        #main-window[sizemode='true'] #toolbar-menubar[autohide='true'] + #TabsToolbar #tabbrowser-tabs {
            --tab-min-height: 30px !important;
        }
        #scrollbutton-up,
        #scrollbutton-down {
            border-top-width: 0 !important;
            border-bottom-width: 0 !important;
        }

        #TabsToolbar, #TabsToolbar > hbox, #TabsToolbar-customization-target, #tabbrowser-arrowscrollbox  {
            max-height: calc(var(--tab-min-height) + 1px) !important;
        }
        #TabsToolbar-customization-target toolbarbutton > .toolbarbutton-icon, 
        #TabsToolbar-customization-target .toolbarbutton-text, 
        #TabsToolbar-customization-target .toolbarbutton-badge-stack,
        #scrollbutton-up,#scrollbutton-down {
            padding-top: 7px !important;
            padding-bottom: 6px !important;
        }

        /*  Clean and tight extensions menu */
        #unified-extensions-view{
            --uei-icon-size: 20px; /*  Change icon size */
        }

        #unified-extensions-panel #unified-extensions-view {
            width: 100% !important;  /*  For firefox v115.x */
        }

        :is(panelview, #widget-overflow-fixed-list) .toolbaritem-combined-buttons {
            margin: 2px 4px !important;  /*  For firefox v115.x / Makes more compact */
        }

        .unified-extensions-item-menu-button.subviewbutton {
            padding: 2px !important;  /*  For firefox v115.x / Fix icon margins */
        }

        #unified-extensions-view .panel-header,
        #unified-extensions-view .panel-header + toolbarseparator,
        #unified-extensions-view .panel-subview-body + toolbarseparator,
        #unified-extensions-view #unified-extensions-manage-extensions,
        #unified-extensions-view .unified-extensions-item-menu-button.subviewbutton {
            display:none !important;
        }
 
        #unified-extensions-view .panel-subview-body {
            padding-top: 2px !important;
            padding-bottom: 2px !important;
        }
 
        #unified-extensions-view .unified-extensions-item .unified-extensions-item-icon,
        #unified-extensions-view .unified-extensions-item .toolbarbutton-badge-stack {
             margin-inline-end: 2px !important;
        }
 
        #unified-extensions-view .unified-extensions-item-name, 
        #unified-extensions-view .unified-extensions-item-message {
            padding-inline-start: 0.5em !important;
            width: 21em !important;
        }
        #unified-extensions-view .unified-extensions-item-action-button.subviewbutton {
            padding-top: 2px !important;
            padding-bottom: 2px !important;
        }
  ";
  };
 };

}
