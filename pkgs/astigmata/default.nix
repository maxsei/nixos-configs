{ stdenvNoCC, fetchurl, unrar-wrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "astigmata-font";
  version = "";

  src = fetchurl {
    url = "https://deathshadow.com/downloads/Astigmata-Regular.rar";
    hash = "sha256-L1ZLKOs3AkZgIwYzZw0JO6JxYp5gtHT9HTSBRxF9+B8=";
  };

  unpackPhase = ''
    runHook preUnpack;

    ${unrar-wrapper}/bin/unrar x $src

    runHook postUnpack;
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/astigmata

    runHook postInstall
  '';
}
