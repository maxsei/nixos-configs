{ config, ... }:
{
  sops.age.sshKeyPaths = [ "/home/mschulte/.ssh/maxsei-homecloud" ];
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets."openconnect/bbt/Password" = { };

  networking.openconnect.interfaces.bbt = {
    user = "maximillian.schulte@bigbrandtire.com";
    gateway = "azure-1-rdkqqgzwjnjc.dynamic-m.com";
    passwordFile = config.sops.secrets."openconnect/bbt/Password".path;
    protocol = "anyconnect";
    autoStart = false;
  };
}
