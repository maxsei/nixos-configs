{
  pkgs ? import <nixpkgs> {},
  ...
}:
let
  catppuccin-alacritty = with pkgs; vimUtils.buildNeovimPluginFrom2Nix {
    pname = "catppuccin-nvim";
    version = "2022-09-13";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "alacritty";
      rev = "406dcd431b1e8866533798d10613cdbab6568619";
      sha256 = "0m788qji98accshd781922dbcvbi929w0rj85c4wvgpahzkl6b27";
    };
    meta.homepage = "https://github.com/catppuccin/alacritty/";
  };
  alacrittyYAML = ''
    import:
      - $out/share/doc/alacritty-base.yml
      - ${catppuccin-alacritty.out}/catppuccin-frappe.yml
  '';
in
pkgs.alacritty.overrideAttrs (final: prev: {
  name = "alacritty-custom";
  # postInstall = final.postInstall + ''
  userHook = "echo helloooooo";
  # postInstall = prev.postInstall + ''
  #   pushd $out/share/doc
  #   mv alacritty.yml alacritty-base.yml
  #   echo ${alacrittyYAML} > alacritty.yml
  #   popd
  # '';
})
