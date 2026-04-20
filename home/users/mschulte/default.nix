{ ... }:
{
  imports = [ ../../config/common.nix ];

  home.username = "mschulte";
  home.homeDirectory = "/home/mschulte";

  programs.git.settings = {
    user.name = "maxsei";
    user.email = "maximilliangschulte@gmail.com";
  };
}
