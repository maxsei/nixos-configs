{ inputs, ... }:
{
  imports = [
    ../../config/common.nix
    ../../modules/hermes-agent
    ./sops.nix
  ];

  home.username = "mschulte";
  home.homeDirectory = "/home/mschulte";

  programs.git.settings = {
    user.name = "maxsei";
    user.email = "maximilliangschulte@gmail.com";
  };
}
