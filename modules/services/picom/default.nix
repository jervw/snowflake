{ config, lib, pkgs, ... }:

{ 
  config = lib.mkIf (config.xsession.enable) {      # Only evaluate code if using X11
    services.picom = {
      enable = false;
      package = pkgs.picom.overrideAttrs(o: {
        src = pkgs.fetchFromGitHub {
          repo = "picom";
          owner = "jonaburg";
          rev = "e3c19cd7d1108d114552267f302548c113278d45";
          sha256 = "4voCAYd0fzJHQjJo4x3RoWz5l3JJbRvgIXn1Kg6nz6Y=";
        };
      });

      backend = "glx";
      vSync = false;

      shadow = false;
      shadowOpacity = 0.75;
      fade = true;      
      fadeDelta = 10;
      opacityRules = [ 
        "80:class_i *= 'Alacritty'"
      ];                         

      settings = {
        daemon = true;
        use-damage = false;     
        resize-damage = 1;
        refresh-rate = 0;
        corner-radius = 5;     
        round-borders = 5;

        # Animations
        transition-length = 300;
        transition-pow-x = 0.5;
        transition-pow-y = 0.5;
        transition-pow-w = 0.5;
        transition-pow-h = 0.5;
        size-transition = true;

        # Extras
        detect-rounded-corners = true;             
        detect-client-opacity = false;
        detect-transient = true;
        detect-client-leader = false;
        mark-wmwim-focused = true;
        mark-ovredir-focues = true;
        unredir-if-possible = true;
        glx-no-stencil = true;
        glx-no-rebind-pixmap = true;
      };                                          
    };
  };
}
