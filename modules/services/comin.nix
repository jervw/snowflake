{inputs, ...}: {
  imports = [
    inputs.comin.nixosModules.comin
  ];

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://codeberg.org/jervw/snowflake.git";
        branches.main.name = "main";
      }
    ];
  };
}
