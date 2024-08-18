_: {
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "small";
      };

      display = {
        separator = "";
        key.width = 12;
      };

      modules = [
        {
          key = " user";
          type = "title";
          format = "{1}@{2}";
          keyColor = "31";
        }
        {
          key = "󰅐 up";
          type = "uptime";
          keyColor = "33";
        }
        {
          key = "󰟾 distro";
          type = "os";
          keyColor = "34";
          format = "{3}";
        }
        {
          key = " kernel";
          type = "kernel";
          keyColor = "35";
        }
        {
          key = "󰇄 desktop";
          type = "de";
          keyColor = "36";
        }
        {
          key = " term";
          type = "terminal";
          keyColor = "31";
          format = "{1}";
        }
        {
          key = " shell";
          type = "shell";
          keyColor = "32";
          format = "{1}";
        }
        {
          key = "󰍛 cpu";
          type = "cpu";
          showPeCoreCount = true;
          keyColor = "33";
        }
        {
          key = "󰉉 disk";
          type = "disk";
          folders = "/";
          keyColor = "34";
        }
        {
          key = " memory";
          type = "memory";
          keyColor = "35";
        }
        {
          key = "󰩟 network";
          type = "localip";
          format = "{1} ({4})";
          keyColor = "36";
        }
        {
          key = " colors";
          type = "colors";
          symbol = "circle";
          keyColor = "39";
        }
      ];
    };
  };
}
