{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "helix-gpt";
  version = "0.15";

  src = fetchurl {
    url = "https://github.com/leona/helix-gpt/releases/download/${version}/helix-gpt-${version}-x86_64-linux.tar.gz";
    hash = "sha256-hZ7JAMXgnrwZjjqzX+M9gQI/AKU8JY3iNrYzP/mRii8=";
  };

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    ls
    install -m755 -D helix-gpt-${version}-x86_64-linux $out/bin/${pname}
    runHook postInstall
  '';

  meta = {
    description = "Code assistant language server for Helix with support for Copilot + OpenAI.";
    homepage = "https://github.com/leona/helix-gpt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [jervw];
    platforms = ["x86_64-linux"];
  };
}
