{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      corefonts
      nerd-fonts.jetbrains-mono
      (google-fonts.override {fonts = ["Inter"];})
    ];
  };
}
