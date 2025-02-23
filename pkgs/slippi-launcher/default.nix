{
  stdenvNoCC,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  dolphin-emu,
}:

stdenvNoCC.mkDerivation rec {
  pname = "slippi-launcher";
  version = "2.11.7";

  src = appimageTools.wrapType2 rec {
    inherit pname version;

    # src = fetchurl {
    #   url = "https://github.com/project-slippi/slippi-launcher/releases/download/v${version}/Slippi-Launcher-${version}-x86_64.AppImage";
    #   hash = "sha256-wlPAbXzUdmu0zQE6H1FfUc4bk3yBptauC+86mwWFrRg=";
    # };
    src = fetchurl {
      url = "https://github.com/project-slippi/Ishiiruka/releases/download/v3.4.3/Slippi_Online-x86_64.AppImage";
      hash = "sha256-9SvYflt9PvxXBjSyF52uO3Znb+Trw1gqmmA6k39UDww=";
    };


    buildInputs = [ makeWrapper ];
    nativeBuildInputs = [ makeWrapper dolphin-emu ];

    postBuild = ''
      wrapProgram $out/bin/slippi-launcher-${version} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    '';
    # postBuild = ''
    #   wrapProgram $out/bin/slippi-launcher-${version}
    # '';

    # extraPkgs = pkgs: with pkgs; [ fuse zlib ];
    extraPkgs = pkgs: with pkgs; [ curl libsndfile libmpg123 ];
  };

  desktopItems = [
    (makeDesktopItem {
      name = "slippi-launcher";
      exec = "slippi-launcher-${version}";
      icon = "slippi-launcher";
      desktopName = "Slippi Launcher";
      comment = "The way to play Slippi Online and watch replays";
      type = "Application";
      categories = [ "Game" ];
      keywords = [
        "slippi"
        "melee"
        "rollback"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -r "$src/bin" "$out"

    runHook postInstall
  '';

  nativeBuildInputs = [ copyDesktopItems ];
}
