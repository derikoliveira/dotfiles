# Neovim Config

Requires **Neovim 0.12+**.

## Tools

### macOS

```bash
brew install lua-language-server zls jdtls stylua clang-format
```

### Arch

```bash
sudo pacman -S lua-language-server zls jdtls stylua clang
```

### Fedora

```bash
sudo dnf install clang-tools-extra
```

- lua-language-server: not in Fedora repos — build from https://github.com/LuaLS/lua-language-server or install via cargo
- stylua: not in Fedora repos — `cargo install stylua` or download from https://github.com/JohnnyMorganz/StyLua/releases
- zls: https://ziglang.org/download
- jdtls: https://github.com/eclipse-jdtls/eclipse.jdt.ls/releases

### Debian / Ubuntu / WSL

```bash
sudo apt install luarocks clang-format
luarocks install --local lua-lsp
```

- zls: https://ziglang.org/download (match your Zig version)
- jdtls: https://github.com/eclipse-jdtls/eclipse.jdt.ls/releases
