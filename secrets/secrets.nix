let
  jervw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfHThh8zEBkr3RTpg0xoFrrL/JQ2VUkXQo/MNYXxsUI";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk7bYxT0obpeDc9w/6n1pUyRv0G/3irfTnutOneH4yb";
in {
  "pia.age".publicKeys = [jervw loki];
}
