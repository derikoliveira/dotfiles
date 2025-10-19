#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
cd "$(dirname "${0}")"

CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

log_info() { echo -e "${*}"; }
log_step() { echo -e "${CYAN}${*}${RESET}"; }
log_error() { echo -e "${RED}${*}${RESET}" >&2; }

trap 'log_error "An unexpected error occurred. Exiting..."; exit 1' ERR
trap 'log_error "\nScript interrupted"; exit 130' INT

if [[ $EUID -eq 0 ]]; then
    # stow and user configs shouldn’t be owned by root
    log_error "Do not run as root. The script will use sudo when needed."
    exit 1
fi

# Request sudo access upfront
sudo -v

DOTFILES_DIR="$(pwd)"
PACKAGES_FILE="${DOTFILES_DIR}/packages.txt"
HELIX_VERSION="25.07.1"

log_step "Starting installation"

log_step "Installing packages"
if [[ -f "${PACKAGES_FILE}" ]]; then
    log_info "Packages file: ${DOTFILES_DIR}"
    sudo apt-get update
    sudo xargs -a "${PACKAGES_FILE}" apt-get install -y
else
    log_error "packages.txt not found in ${DOTFILES_DIR}"
    exit 1
fi

log_step "Stowing dotfiles"
mkdir -p "${HOME}/.config"
for pkg in git helix zsh zshenv; do
    if [[ -d "${pkg}" ]]; then
        stow -v -R -t "${HOME}" "${pkg}"
    else
        log_error "Missing package folder '${pkg}'"
        exit 1
    fi
done

log_step "Installing Pure prompt"
PURE_DIR="${HOME}/.config/zsh/pure"
if [[ ! -d "${PURE_DIR}" ]]; then
    git clone https://github.com/sindresorhus/pure.git "${PURE_DIR}"
else
    echo "Pure already installed, pulling latest changes"
    git -C "${PURE_DIR}" pull
fi

log_step "Changing default shell to zsh"
if [[ "${SHELL}" != "$(command -v zsh)" ]]; then
    sudo chsh -s "$(command -v zsh)" "$(whoami)"
else
    log_info "Zsh already set as default shell"
fi

log_step "Installing Helix"
if ! command -v hx > /dev/null 2>&1; then
    HELIX_TAR="helix-${HELIX_VERSION}-x86_64-linux.tar.xz"
    HELIX_DIR="helix-${HELIX_VERSION}-x86_64-linux"
    curl -LO "https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/${HELIX_TAR}"
    tar -xJf "${HELIX_TAR}"
    sudo mv "${HELIX_DIR}" /opt/helix
    sudo ln -sf /opt/helix/hx /usr/local/bin/hx
    rm -f "${HELIX_TAR}"
else
    log_info "Helix already installed, skipping"
fi

log_step "Installing uv"
if ! command -v uv > /dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="${HOME}/.local/bin:$PATH"
else
    log_info "uv is already installed, updating"
    uv self update
fi

log_step "Installing uv packages"
uv tool install --upgrade ruff@latest
uv tool install --upgrade basedpyright@latest

log_step "Installing docker"
if ! command -v docker > /dev/null 2>&1; then
    # Uninstall all conflicting packages
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
        sudo apt-get remove -y "${pkg}" 2>/dev/null || true;
    done
    # Add Docker's official GPG key:
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # Install
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    # Run docker without sudo
    if ! getent group docker > /dev/null 2>&1; then
        sudo groupadd docker
    fi
    sudo usermod -aG docker $USER
    log_info "Added ${USER} to docker group. Log out and log back in (or run 'newgrp docker') to apply"
else
    log_info "Docker is already installed, skipping"
fi

log_step "Installation complete"
