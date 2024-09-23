{ pkgs }:
pkgs.symlinkJoin {
  name = "alacritty";
  paths = [ pkgs.alacritty ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    mkdir -p $out/etc
    cp ${./alacritty.toml} $out/etc/alacritty.toml
    cp ${./catppuccin-machiato.toml} $out/etc/catppuccin-machiato.toml

    substituteInPlace $out/etc/alacritty.toml \
      --replace "./catppuccin-mocha.toml" "$out/etc/catppuccin-mocha.toml"


    wrapProgram $out/bin/alacritty \
      --set WAYLAND_DISPLAY "" \
      --add-flags "--config-file $out/etc/alacritty.toml"
  '';
}
