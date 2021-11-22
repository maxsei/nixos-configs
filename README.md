# Nixos Configs
1. Follow nixos installation guide
2. clone to root's home directory
3. symlink the host of choice to /etc/nixos
```sh
ln -s /root/nixos-configs/hosts/<hostname>/configuration.nix /etc/nixos/configuration.nix
```
4. reboot
