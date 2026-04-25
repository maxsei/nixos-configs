{ pkgs, ... }:
let
  fenix = pkgs.fenix;
  components =
    map
      (
        c:
        (fenix.toolchainOf c).withComponents [
          "rustc"
          "cargo"
          "rustfmt"
          "clippy"
        ]
      )
      [
        {
          channel = "1.94.0";
          sha256 = "sha256-qqF33vNuAdU5vua96VKVIwuc43j4EFeEXbjQ6+l4mO4=";
        }
        {
          channel = "1.95.0";
          sha256 = "sha256-gh/xTkxKHL4eiRXzWv8KP7vfjSk61Iq48x47BEDFgfk=";
        }
      ];
  toolchain = (fenix.combine ([ fenix.latest.toolchain ] ++ components));
in
{
  home.packages = [ toolchain ];
}
