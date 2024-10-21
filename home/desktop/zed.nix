_: {
  programs.zed-editor = {
    enable = true;
    userSettings = {
      assistant = {
        default_model = {
          provider = "copilot_chat";
          model = "gpt-4o";
        };
        version = "2";
      };
      features = {
        inline_completion_provider = "copilot";
      };
      vim_mode = true;
      ui_font_size = 18;
      buffer_font_size = 16;
      theme = {
        mode = "system";
        light = "One Dark";
        dark = "One Dark";
      };
    };
  };
}
