# Nixos Configs
1. Follow nixos installation guide
2. clone to root's home directory
3. symlink the host of choice to /etc/nixos
```sh
ln -s /root/nixos-configs/hosts/<hostname>/configuration.nix /etc/nixos/configuration.nix
```
4. reboot

TODO:
On build we want users that are in wheel to be able to read and write to the nixos-configs in root.  They can symlink it somewhere in their user directory if needed.  In fact I prefer this and might add this in home manager.
`[-d /root/nixos-configs ] || git clone git@github.com:maxsei/nixos-configs.git /root/nixos-configs`
`chown root:wheel /root`
`chmod 0770 /root`
`chown root:wheel -R /root/nixos-configs`
`find /root/nixos-configs -type d -exec chmod 0770 {} \;`
`find /root/nixos-configs -type f -exec chmod 0660 {} \;`


### Workflow
This repo should exist in the /home/<user> for the explicit purpose of building and debugging inside of a vm.  One tested clone somewhere with root and symlink to `/etc/nixos/configuration.nix`
