{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        size = 14;
      };

      window = {
        opacity = 0.9;
        padding = {
          x = 10;
          y = 10;
        };
<<<<<<< HEAD
    };
    };
=======
      };
>>>>>>> 2a79b2b (git and alacritty nix modules)
    };
  };
}
