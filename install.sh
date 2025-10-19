#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
cd "$(dirname "$0")"

CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

log_info() { echo -e "$*"; }

log_step() { echo -e "$CYAN$*$RESET"; }

log_error() { echo -e "$RED$*$RESET" >&2; }

trap 'log_error "An unexpected error occurred. Exiting..."; exit 1' ERR
trap 'log_error "\nScript interrupted"; exit 130' INT

if [[ $EUID -eq 0 ]]; then
    # stow and user configs shouldn’t be owned by root
    log_error "Do not run as root. The script will use sudo when needed."
    exit 1
fi

DOTFILES_DIR="$(pwd)"
PACKAGES_FILE="$DOTFILES_DIR/packages.txt"
HELIX_VERSION="25.07.1"

log_step "Starting installation"

log_step "Installing packages"
if [[ -f "$PACKAGES_FILE" ]]; then
    log_info "Packages file: $DOTFILES_DIR"
    sudo xargs -a "$PACKAGES_FILE" apt install -y
else
    log_error "packages.txt not found in $DOTFILES_DIR"
fi

log_step "Stowing dotfiles"
mkdir -p "$HOME/.config"
for pkg in git helix zsh zshenv; do
    if [[ -d "$pkg" ]]; then
        stow -v -R -t "$HOME" "$pkg"
    else
        log_error "Missing package folder '$pkg'"
        exit 1
    fi
done

log_step "Installing Pure prompt"
PURE_DIR="$HOME/.config/zsh/pure"
if [[ ! -d "$PURE_DIR" ]]; then
    git clone https://github.com/sindresorhus/pure.git "$PURE_DIR"
else
    echo "Pure already installed, pulling latest changes"
    git -C "$PURE_DIR" pull
fi

log_step "Installing Helix"
if ! command -v hx > /dev/null 2>&1; then
    HELIX_TAR="helix-${HELIX_VERSION}-x86_64-linux.tar.xz"
    HELIX_DIR="helix-${HELIX_VERSION}-x86_64-linux"
    curl -LO "https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/${HELIX_TAR}"
    tar -xJf "$HELIX_TAR"
    sudo mv "$HELIX_DIR" /opt/helix
    sudo ln -sf /opt/helix/hx /usr/local/bin/hx
    rm -f "$HELIX_TAR"
else
    log_info "Helix already installed, skipping"
fi

log_step "Installing uv"
if ! command -v uv > /dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    log_info "uv is already installed, updating"
    uv self update
fi

log_step "Installing uv packages"
UV_PATH="$(command -v uv || echo "$HOME/.local/bin/uv")"
$UV_PATH tool install --upgrade ruff@latest
$UV_PATH tool install --upgrade basedpyright@latest

log_step "Changing default shell to zsh"
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)"
else
    log_info "Zsh already set as default shell"
fi

log_step "Installation complete"
