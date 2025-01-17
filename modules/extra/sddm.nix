{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [
    (
      pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = config.stylix.fonts.serif.name;
        fontSize = toString config.stylix.fonts.sizes.desktop;
        background = config.stylix.image;
        loginBackground = true;
      }
    )
  ];

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "catppuccin-mocha";
    wayland = {
      enable = true;
      compositor = "weston";
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;
}
