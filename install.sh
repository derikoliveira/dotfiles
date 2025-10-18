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
for pkg in git helix zed zsh zshenv; do
    if [[ -d "$pkg" ]]; then
        stow -v -R -t "$HOME" "$pkg"
    else
        err "Warning: missing package folder '$pkg'"
    fi
done

if ! command -v hx > /dev/null 2>&1; then
    log "Installing Helix"
    curl -LO https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-x86_64-linux.tar.xz
    tar -xJf helix-25.07.1-x86_64-linux.tar.xz
    sudo mv helix-25.07.1-x86_64-linux /opt/helix
    sudo ln -sf /opt/helix/hx /usr/local/bin/hx
    rm -f helix-25.07.1-x86_64-linux.tar.xz
else
    log "Helix already installed, skipping"
fi

if ! command -v uv > /dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    log "uv is already installed, skipping"
fi

if ! command -v ruff > /dev/null 2>&1; then
    uv tool install ruff@latest
else
    log "ruff is already installed, skipping"
fi

if ! command -v basedpyright > /dev/null 2>&1; then
    uv tool install basedpyright@latest
else
    log "basedpyright is already installed, skipping"
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
