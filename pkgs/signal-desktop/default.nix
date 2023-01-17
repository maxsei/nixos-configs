{ pkgs ? import <nixpkgs> { }, lib, fetchurl, ... }:
pkgs.signal-desktop.overrideAttrs (final: prev: rec {
  version = "6.2.0";
  src = fetchurl {
    url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
    sha256 = "sha256-auOcMlwKPj5rsnlhK34sYe4JxlHCjb3e2ye8Cs12Qtc=";
  };
})
