{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      corefonts
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      (google-fonts.override {fonts = ["Inter"];})
    ];
  };
}
