{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;
  cfg = config.${namespace}.programs.apps.discord;
in {
  options.${namespace}.programs.apps.discord = {
    enable = lib.mkEnableOption "Enable Discord";
  };
  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
      discord = {
        equicord = enabled;
        krisp = enabled;
        openASAR = enabled;
      };
      config.plugins = {
        altKrispSwitch = enabled;
        alwaysTrust = enabled;
        betterAudioPlayer = enabled;
        biggerStreamPreview = enabled;
        callTimer = enabled;
        clearUrls = enabled;
        collapsibleUi = enabled;
        concatenatedComponentExtractor = enabled;
        consoleJanitor = enabled;
        declutter = enabled;
        dontRoundMyTimestamps = enabled;
        fakeNitro = enabled;
        fixCodeblockGap = enabled;
        fixSpotifyEmbeds = enabled;
        fixYoutubeEmbeds = enabled;
        fullVcpfp = enabled;
        mentionAvatars = enabled;
        messageLogger = enabled;
        messageLoggerEnhanced = enabled;
        noF1 = enabled;
        noNitroUpsell = enabled;
        noTrack = enabled;
        noTypingAnimation = enabled;
        quickMention = enabled;
        roleColorEverywhere = enabled;
        showHiddenChannels = enabled;
        songLink = enabled;
        spotifyCrack = enabled;
        supportHelper = enabled;
        voiceRejoin = enabled;
        volumeBooster = enabled;
        whoReacted = enabled;
        whosWatching = enabled;
        youtubeAdblock = enabled;
        zipPreview = enabled;
      };
    };
  };
}
