# Universal configuration file for all hosts

{ config, lib, pkgs, user, ...}:

{
  programs.fish.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    rtkit.enable = true;
    polkit.enable = true;

    doas.enable = true;
    sudo.enable = false;
    doas.extraRules = [{
      users = [ user ];
      keepEnv = true;
      persist = true;
    }];
  };

  environment = {
    variables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      git
      killall
      wget
      nano
    ];
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    corefonts
    (nerdfonts.override { fonts = ["JetBrainsMono"]; })
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
  };

  system.stateVersion = "22.11";
}
