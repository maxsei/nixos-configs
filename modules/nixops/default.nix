{ environment, nixpkgs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixops
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-pyjwt-1.7.1"
  ];
}
