# Hey, I bet you're here because signal is telling you that you must update. Run
# the following command to get the latest version number.
# $ curl https://api.github.com/repos/signalapp/Signal-Desktop/releases/latest | grep tag_name
{ callPackage }:
callPackage ./generic.nix {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.14.0";
  hash = "sha256-nRvGpAKRIPgXStrVu4qSMoW01SACV/wW/c05lLncCW8=";
}
