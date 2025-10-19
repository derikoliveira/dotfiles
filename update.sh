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
PACKAGES_FILE="${DOTFILES_DIR}/packages.txt"

log_step "Starting update"

log_step "Upgrade packages"
sudo apt update
sudo xargs -a "${PACKAGES_FILE}" apt upgrade -y

PURE_DIR="${HOME}/.config/zsh/pure"
if [[ -d "${PURE_DIR}" ]]; then
    log_step "Updating pure prompt"
    git -C "${PURE_DIR}" pull
fi

if command -v uv > /dev/null 2>&1; then
    log_step "Updating uv"
    uv self update

    if command -v ruff > /dev/null 2>&1; then
        log_step "Updating ruff"
        uv tool upgrade ruff
    fi

    if command -v basedpyright > /dev/null 2>&1; then
        log_step "Updating basedpyright"
        uv tool upgrade basedpyright
    fi
fi

log_step "Update finished"
