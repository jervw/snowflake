{
  lib,
  namespace,
  ...
}: {
  options.${namespace}.user = with lib; {
    name = mkOpt str "jervw" "The name to use for the user account.";
    fullName = mkOpt str "Jere Vuola" "The full name of the user.";
    email = mkOpt str "jervw@pm.me" "The email of the user.";
  };
}
