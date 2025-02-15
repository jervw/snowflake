{pkgs, ...}: {
  environment.systemPackages = [pkgs.alpaca pkgs.smartcat];

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    models = "/mnt/storage/ollama-models";
    loadModels = [
      "deepseek-r1:8b"
      "opencoder:8b"
    ];
  };
}
