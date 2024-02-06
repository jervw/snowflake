{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      monaspace
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      corefonts
      (callPackage ../../pkgs/apple-fonts {})
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };
}
