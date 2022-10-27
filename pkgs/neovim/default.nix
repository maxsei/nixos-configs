# ...
{ pkgs ? import <nixpkgs> { }, lib, ... }:
let plugins-extra = (pkgs.callPackage ./plugins.nix { inherit pkgs; });
in pkgs.neovim.override {
  vimAlias = true;
  configure = {
    packages.myplugins = with pkgs.vimPlugins; {
      start = [ vim-nix vim-commentary ] ++ (builtins.filter lib.isDerivation
        (builtins.attrValues plugins-extra));
    };
    customRC = builtins.readFile (./vimrc);
  };
}
