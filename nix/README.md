# NixOS

NixOS system config and home-manager, managed as a flake.

## Notes

### Hardware config

`hardware-configuration.nix` is gitignored on purpose — it's tied to this
specific machine's disks/UUIDs and isn't portable. On a new machine,
regenerate it with:

```bash
sudo nixos-generate-config --show-hardware-config > <nix-config-path>
```

### Passwords

User passwords are not set declaratively in `configuration.nix`. After the
user account exists, set the password manually:

```bash
sudo passwd derik
sudo passwd cossen
```

### Applying changes

```bash
sudo nixos-rebuild switch --flake /etc/nixos
```
