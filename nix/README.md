# NixOS

NixOS system config and home-manager, managed with channels (nixos-unstable and home-manager master).

## Notes

### Passwords

User passwords are not set declaratively in `configuration.nix`. After the
user account exists, set the password manually:

```bash
sudo passwd derik
sudo passwd cossen
```

### Channels

Set up once, as root:

```bash
sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --update
```

### Applying changes

```bash
sudo nixos-rebuild switch
```

### Updating

`system.autoUpgrade` updates all channels and rebuilds daily, so there's nothing
to do by hand. To update now:

```bash
sudo nixos-rebuild switch --upgrade-all
```

### Updating Helium

Helium isn't in nixpkgs, so it's packaged in `helium.nix` and pinned to a
release. Check the latest version at
<https://github.com/imputnet/helium-linux/releases>, then get its hash:

```bash
nix store prefetch-file https://github.com/imputnet/helium-linux/releases/download/<version>/helium-<version>-x86_64_linux.tar.xz
```

Set `version` and `hash` in `helium.nix` to the new values, then rebuild.
