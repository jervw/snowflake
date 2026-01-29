{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.freetube;
in {
  options.${namespace}.programs.apps.freetube = {
    enable = lib.mkEnableOption "Enable FreeTube";
  };

  config = mkIf cfg.enable {
    programs.freetube = {
      enable = true;
      settings = {
        quickBookmarkTargetPlaylistId = "favorites";
        checkForUpdates = false;
        checkForBlogPosts = false;
        barColor = false;
        baseTheme = "system";
        mainColor = "CatppuccinMochaRed";
        secColor = "CatppuccinMochaRed";
        expandSideBar = true;
        hideLabelsSideBar = true;
        hideHeaderLogo = true;
        defaultTheatreMode = true;
        allowDashAv1Formats = true;
        defaultQuality = "1440";
        hideTrendingVideos = true;
        hidePopularVideos = true;
        useSponsorBlock = true;
        useDeArrowTitles = true;
      };
    };
  };
}
