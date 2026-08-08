# Dotfiles

My configs in one place, plus what's needed to bring up a new machine.

Each tool gets its own directory, symlinked into place with [GNU
Stow](https://www.gnu.org/software/stow/), so a machine takes only what it
needs. Package lists cover macOS, Arch, Debian/Ubuntu, and Fedora. No install
script and nothing to learn: clone, install the packages, stow what you want.

## Setup

### 1. Clone

```bash
git clone https://github.com/derikoliveira/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
```

### 2. Install packages

#### macOS

```bash
brew install $(cat packages/brew.txt)
```

#### Arch

```bash
sudo pacman -S $(cat packages/pacman.txt)
```

#### Debian / Ubuntu / WSL

```bash
sudo apt-get update && sudo xargs apt-get install -y < packages/apt.txt
```

#### Fedora

```bash
sudo dnf install $(cat packages/dnf.txt)
```

#### Manual installs

| Tool                                                          | Platforms | Reason                                      |
| ------------------------------------------------------------- | --------- | ------------------------------------------- |
| [Neovim](https://github.com/neovim/neovim/releases)           | All       | Package managers may ship outdated versions |
| [uv](https://docs.astral.sh/uv/getting-started/installation/) | apt       | Not in standard apt repos                   |
| [Docker](https://docs.docker.com/engine/install/)             | apt, dnf  | Not in standard apt/dnf repos               |
| [Rust (rustup)](https://rustup.rs)                            | All       | Package managers may ship outdated versions |
| [nvm](https://github.com/nvm-sh/nvm#installing-and-updating)  | All       | Not available via package managers          |

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
stow -t $HOME git ghostty nvim zsh zshenv
```

### 6. Set zsh as default shell

```bash
chsh -s $(which zsh)
```
