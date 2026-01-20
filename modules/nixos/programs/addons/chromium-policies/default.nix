{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.addons.chromium-policies;
in {
  options.${namespace}.programs.addons.chromium-policies = {
    enable = lib.mkEnableOption "Enable policies applied to chromium browsers";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;

      # extensions = [
      #   "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      #   "gbefmodhlophhakmoecijeppjblibmie" # Linguist
      #   "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      # ];

      extraOpts = {
        # Brave features
        BraveAIChatEnabled = false;
        BraveNewsDisabled = true;
        BraveP3AEnabled = false;
        BravePlaylistEnabled = false;
        BraveRewardsDisabled = true;
        BraveSpeedreaderEnabled = false;
        BraveStatsPingEnabled = false;
        BraveTalkDisabled = true;
        BraveVPNDisabled = true;
        BraveWalletDisabled = true;
        BraveWaybackMachineEnabled = true;
        BraveWebDiscoveryEnabled = false;
        TorDisabled = true;

        # Default permission settings (2 = block)
        DefaultGeolocationSetting = 2;
        DefaultLocalFontsSetting = 2;
        DefaultNotificationsSetting = 2;
        DefaultSensorsSetting = 2;
        DefaultSerialGuardSetting = 2;

        # Reporting and telemetry
        CloudReportingEnabled = false;
        MetricsReportingEnabled = false;
        UrlKeyedAnonymizedDataCollectionEnabled = false;
        FeedbackSurveysEnabled = false;

        # Safe browsing
        AlternateErrorPagesEnabled = false;
        SafeBrowsingDeepScanningEnabled = false;
        SafeBrowsingExtendedReportingEnabled = false;
        SafeBrowsingProtectionLevel = 1;
        SafeBrowsingSurveysEnabled = false;

        # Autofill & passwords
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        PasswordLeakDetectionEnabled = false;
        PasswordManagerEnabled = false;
        PasswordSharingEnabled = false;

        # Privacy & security
        BlockThirdPartyCookies = true;
        EnableDoNotTrack = true;
        HttpsOnlyMode = "force_enabled";
        PrivacySandboxAdTopicsEnabled = false;
        PrivacySandboxSiteEnabledAdsEnabled = false;
        PrivacySandboxAdMeasurementEnabled = false;
        PrivacySandboxFingerprintingProtectionEnabled = true;
        PrivacySandboxIpProtectionEnabled = true;
        RelatedWebsiteSetsEnabled = false;
        WebRtcIPHandling = "disable_non_proxied_udp";

        # Networking
        DnsOverHttpsMode = "automatic";
        QuicAllowed = true;
        BuiltinDnsClientEnabled = false;

        # Search provider
        SearchSuggestEnabled = true;

        # Browser behavior
        DefaultBrowserSettingEnabled = false;
        BackgroundModeEnabled = false;
        BrowserGuestModeEnabled = false;
        BrowserSignin = 0;

        # Downloads
        AlwaysOpenPdfExternally = true;

        # Extensions
        ExtensionManifestV2Availability = 2;

        # Misc
        TranslateEnabled = false;

        # Data hygiene
        ClearBrowsingDataOnExitList = [
          "download_history"
        ];
      };
    };
  };
}
