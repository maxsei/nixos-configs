# Nixos Configs

## Folder Structure

```
home/
  config/     # Reusable home-manager configurations shared across users
  users/      # Per-user home-manager entrypoints
modules/      # Custom modules that define new (typically nixos) options/services
pkgs/         # Custom derivations not in nixpkgs
system/
  config/     # Reusable NixOS configurations shared across hosts
  hosts/      # Per-host NixOS entrypoints
```
