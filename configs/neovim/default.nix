{ nixvim, system, ... }:
nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit system;
  module = import ./config;
}
