{ ... }:
{
  imports = [ ../../config/common.nix ];

  home.username = "mschulte71";
  home.homeDirectory = "/home/mschulte71";

  programs.git.settings = {
    user.name = "mschulte71";
    user.email = "maximillian.schulte@bigbrandtire.com";
  };
}
