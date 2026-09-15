{ inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.default
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };
}
