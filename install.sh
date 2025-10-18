#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

DOTFILES_DIR="$(pwd)"
PACKAGES_FILE="$DOTFILES_DIR/packages.txt"

log() {
    echo -e "\033[1;32m[+] $1\033[0m"
}

err() {
    echo -e "\033[1;31m[!] $1\033[0m" >&2
}

if [[ $EUID -eq 0 ]]; then
    # stow and user configs shouldn’t be owned by root
    err "Do not run as root. The script will use sudo when needed."
    exit 1
fi

log "Starting installation"

if [[ -f "$PACKAGES_FILE" ]]; then
    log "Installing packages from $PACKAGES_FILE"
    sudo xargs -a "$PACKAGES_FILE" apt install -y
else
    err "packages.txt not found in $DOTFILES_DIR"
fi

mkdir -p "$HOME/.config"

log "Stowing dotfiles"
cd "$DOTFILES_DIR"
for pkg in git nvim zed zsh zshenv; do
    if [[ -d "$pkg" ]]; then
        stow -v -R -t "$HOME" "$pkg"
    else
        err "Warning: missing package folder '$pkg'"
    fi
done

if ! command -v nvim >/dev/null 2>&1; then
    log "Installing Neovim nightly"
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
    tar -xzf nvim-linux-x86_64.tar.gz
    sudo mv nvim-linux-x86_64 /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm -f nvim-linux-x86_64.tar.gz
else
  log "Neovim already installed, skipping"
fi

PURE_DIR="$HOME/.config/zsh/pure"
if [[ ! -d "$PURE_DIR" ]]; then
    log "Installing Pure prompt"
    git clone https://github.com/sindresorhus/pure.git "$PURE_DIR"
else
    log "Pure already installed, pulling latest changes"
    git -C "$PURE_DIR" pull
fi

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    log "Changing default shell to zsh"
    chsh -s "$(command -v zsh)"
else
    log "Zsh already set as default shell"
fi

log "Installation complete"
