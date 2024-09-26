_: {
  programs.freetube = {
    enable = true;
    settings = {
      defaultInvidiousInstance = "https://iv.jervw.dev/";
      quickBookmarkTargetPlaylistId = "favorites";
      checkForUpdates = false;
      checkForBlogPosts = false;
      barColor = false;
      baseTheme = "black";
      mainColor = "Red";
      expandSideBar = true;
      hideLabelsSideBar = true;
      hideHeaderLogo = true;
      defaultTheatreMode = true;
      allowDashAv1Formats = true;
      defaultQuality = "1080";
      hideTrendingVideos = true;
      hidePopularVideos = true;
      useSponsorBlock = true;
      useDeArrowTitles = true;
    };
  };
}
