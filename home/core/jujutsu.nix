{config, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      name = config.programs.git.userName;
      email = config.programs.git.userEmail;
    };
  };
}
