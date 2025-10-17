# My dotfiles

## Dependencies

- Git
- [Stow](https://www.gnu.org/software/stow/)

## Instalation

```git clone https://github.com/derikoliveira/dotfiles.git && cd dotfiles```

## Usage

Link the directories using stow

```stow <directory_name>```

## Install packages

```sudo xargs -a packages.txt apt install -y```

### Packages with manual instalation

#### Neovim

[GitHub](https://github.com/neovim/neovim)

```bash
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz && rm nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
```

#### Pure

[GitHub](https://github.com/sindresorhus/pure)

```bash
mkdir -p "$HOME/.config/zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.config/zsh"
```
