{ stdenv, lib, fetchurl, autoPatchelfHook }:

assert builtins.currentSystem == "x86_64-linux";

stdenv.mkDerivation rec {
  pname = "spacetimedb";
  version = "0.8.1-beta";

  src = fetchurl {
    url =
      "https://github.com/clockworklabs/SpacetimeDB/releases/download/v${version}/spacetime.linux-amd64.tar.gz";
    hash = "sha256-PkvFk4EgMgi4vo+6oXTF4satOowDR6w35K02j694KLE=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D spacetime $out/bin/spacetime
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://spacetimedb.com";
    description = "The easiest way to build a multiplayer app";
    platforms = platforms.linux;
  };
}
