# Universal configuration file for all hosts

{ config, lib, pkgs, user, ... }:

{
  imports = [ ./../modules/virtualisation.nix ];

  programs.zsh.enable = true;

  # User management
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "doas" "libvirtd"];
    shell = pkgs.zsh;
    initialPassword = "password";
  };

  # Set the localisation
  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.enable = false;

    doas = {
      enable = true;
      wheelNeedsPassword = false;

      extraRules = [{
        users = [ user ];
        keepEnv = true;
        noPass = true;
      }];
    };

  };

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      git
      killall
      tmux
      wget
      nano
      gsettings-desktop-schemas
      glib
    ];
  };

  # Font management
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    corefonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
