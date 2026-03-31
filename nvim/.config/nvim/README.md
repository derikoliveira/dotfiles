# Neovim Config

Requires **Neovim 0.12+**.

## LSP Servers

**macOS**
```bash
brew install lua-language-server zls jdtls
```

**Arch**
```bash
sudo pacman -S lua-language-server zls jdtls
```

**Debian / Ubuntu / WSL**
```bash
sudo apt install luarocks
luarocks install --local lua-lsp
```
- zls: https://ziglang.org/download (match your Zig version)
- jdtls: https://github.com/eclipse-jdtls/eclipse.jdt.ls/releases
