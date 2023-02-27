{ pkgs }:
pkgs.symlinkJoin {
  name = "alacritty";
  paths = [ pkgs.alacritty ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    mkdir -p $out/etc
    cp ${./alacritty.yml} $out/etc/alacritty.yml
    cp ${./catppuccin-machiato.yml} $out/etc/catppuccin-machiato.yml

    substituteInPlace $out/etc/alacritty.yml \
      --replace "./catppuccin-mocha.yml" "$out/etc/catppuccin-mocha.yml"


    wrapProgram $out/bin/alacritty \
      --set WAYLAND_DISPLAY "" \
      --add-flags "--config-file $out/etc/alacritty.yml"
  '';
}
