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

### Updating

`system.autoUpgrade` rebuilds daily against the latest inputs without writing
`flake.lock`, so there's nothing to do by hand. To bump the lock manually:

```bash
nix flake update
sudo nixos-rebuild switch --flake /etc/nixos
```

### Updating Helium

Helium isn't in nixpkgs, so it's packaged in `helium.nix` and pinned to a
release. Check the latest version at
<https://github.com/imputnet/helium-linux/releases>, then get its hash:

```bash
nix store prefetch-file https://github.com/imputnet/helium-linux/releases/download/<version>/helium-<version>-x86_64_linux.tar.xz
```

Set `version` and `hash` in `helium.nix` to the new values, then rebuild.
