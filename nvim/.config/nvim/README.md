# Neovim Config

Requires **Neovim 0.12+**.

## Tools

**macOS**
```bash
brew install lua-language-server zls jdtls stylua clang-format
```

**Arch**
```bash
sudo pacman -S lua-language-server zls jdtls stylua clang
```

**Debian / Ubuntu / WSL**
```bash
sudo apt install luarocks clang-format
luarocks install --local lua-lsp
```
- zls: https://ziglang.org/download (match your Zig version)
- jdtls: https://github.com/eclipse-jdtls/eclipse.jdt.ls/releases
