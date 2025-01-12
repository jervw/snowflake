{
  inputs,
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = "${self}/wallpapers/lock.png";
    polarity = "dark";
    fonts = {
      sizes = {
        terminal = 13;
        desktop = 12;
        popups = 12;
      };

      serif = {
        package = pkgs.google-fonts.override {fonts = ["Inter"];};
        name = "Inter";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Propo";
      };

      sansSerif = config.stylix.fonts.serif;
      emoji = config.stylix.fonts.monospace;
    };
    cursor = {
      package = pkgs.dracula-theme;
      name = "Dracula-cursors";
      size = 16;
    };

    opacity = {
      desktop = 1.0;
      terminal = 0.8;
      popups = 0.8;
    };
  };

  fonts = {
    enableDefaultPackages = false;
    packages = [pkgs.noto-fonts-emoji pkgs.font-awesome];
  };
}
