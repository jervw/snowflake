{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/decaf.yaml";
    image = pkgs.fetchurl {
      url = "https://r2.jervw.dev/wallhaven-9mg5zd.png";
      sha256 = "60b6a9522d22c452c9b20cb17b875cd6fdfd1fb7ae5b1a1087031e1ba791353a";
    };
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
    packages = with pkgs; [
      jetbrains-mono
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
    ];
  };
}
