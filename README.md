# Nixos Configs

The configuration of my [nixos](https://nixos.org/) hosts.

## Building Configurations
```console
# nixos-rebuild switch --flake .#<host>
```

## Conventions
* `hosts` contains configurations that specific to a host (machine) by name of the host
* `modules` contains nixos modules (common nixos configuration)
* `pkgs` contains customised [nixpkgs](https://github.com/NixOS/nixpkgs)
