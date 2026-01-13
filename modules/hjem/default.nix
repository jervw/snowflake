{
  inputs,
  user,
  ...
}: {
  imports = [
    inputs.hjem.nixosModules.default
  ];
  config = {
    hjem = {
      extraModules = [
        inputs.hjem-rum.hjemModules.default
      ];
      users.${user} = {
        enable = true;
        directory = "/home/${user}";
      };
      clobberByDefault = true;
    };
  };
}
