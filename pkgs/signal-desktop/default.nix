# Hey, I bet you're here because signal is telling you that you must update. Run
# the following command to get the latest version number.
# $ curl https://api.github.com/repos/signalapp/Signal-Desktop/releases/latest | grep tag_name
{ callPackage }:
callPackage ./generic.nix {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.81.0";
  hash = "sha256-wvZdpIJAzU0M57lMI0U5UuZ5lK4Pnc13xQSHhUownHg=";
}
