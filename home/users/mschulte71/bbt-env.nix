{ pkgs, ... }:
let
  bbt-env = pkgs.buildFHSEnv {
    name = "bbt-env";
    targetPkgs =
      p: with p; [
        openssl
        openssl.dev
        glib.dev
        libxml2
        libxml2.dev
        libclang.lib
        xmlsec
        xmlsec.dev
        libxslt.dev
        libtool
      ];
  };
in
{
  home.packages = with pkgs; [
    bbt-env
    postgresql
    azure-cli
    concurrently
    buf
    pkg-config
    sops
    ssh-to-age
    openconnect
    opentofu
    sqlcmd
    nodemon
    vitejs
    prettier
    grpc-tools
  ];
}
