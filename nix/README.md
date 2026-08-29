# NixOS

NixOS system config and home-manager, managed as a flake.

## Notes

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
