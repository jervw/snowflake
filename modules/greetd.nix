{ user, ...}: 
{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = user;
      };
      default_session = initial_session;
    };
  };
}
