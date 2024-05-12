_: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font Mono:size=14";
        pad = "10x10 center";
        notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
        selection-target = "clipboard";
      };

      scrollback = {
        lines = 10000;
        multiplier = 3;
      };

      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file";
        uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
      };

      cursor = {
        style = "beam";
        color = "dfdfe0 dfdfe0";
        beam-thickness = 1;
      };

      colors = {
        alpha = 0.9;
        foreground = "abb2bf";
        background = "282c34";
        regular0 = "2c323c";
        regular1 = "e06c75";
        regular2 = "98c379";
        regular3 = "e5c07b";
        regular4 = "61afef";
        regular5 = "c678dd";
        regular6 = "56b6c2";
        regular7 = "5c6370";
        bright0 = "3e4452";
        bright1 = "e06c75";
        bright2 = "98c379";
        bright3 = "e5c07b";
        bright4 = "61afef";
        bright5 = "c678dd";
        bright6 = "56b6c2";
        bright7 = "abb2bf";
      };
    };
  };
}
