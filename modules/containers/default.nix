{ ... }:

{
  virtualisation.oci-containers.containers = {
    test = {
      image = "library/hello-world";
    };
  };
}