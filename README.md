# Dotfiles

Personal configs managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Configs

| Package | Description |
|---------|-------------|
| `git`   | Git config |
| `nvim`  | Neovim config |
| `zed`   | Zed editor (vim mode, Python LSP) |
| `zsh`   | Zsh (Pure prompt, FZF, zoxide, aliases) |
| `zshenv`| ZDOTDIR export |

## Setup

### 1. Clone

```bash
git clone https://github.com/derikoliveira/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
```

### 2. Install packages

**macOS**
```bash
brew install $(cat packages/brew.txt)
```

**Arch**
```bash
sudo pacman -S $(cat packages/pacman.txt)
```

**Debian / Ubuntu / WSL**
```bash
sudo apt-get update && sudo xargs apt-get install -y < packages/apt.txt
```

> **apt only:** Install [uv](https://docs.astral.sh/uv/getting-started/installation/) and [Docker](https://docs.docker.com/engine/install/) manually — they're not in standard apt repos.

### 3. Install Python tools (via uv)

```bash
uv tool install ruff
uv tool install basedpyright
```

### 4. Install Pure prompt

```bash
git clone https://github.com/sindresorhus/pure.git ~/.config/zsh/pure
```

### 5. Stow configs

```bash
stow git nvim zed zsh zshenv
```

### 6. Set zsh as default shell

```bash
chsh -s $(which zsh)
```
