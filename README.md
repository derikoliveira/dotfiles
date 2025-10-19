# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

This repository includes configurations for:

- **git**
- **helix**
- **zed**
- **zsh** (with [pure](https://github.com/sindresorhus/pure) prompt)

## Installation

Clone this repository:

```bash
git clone https://github.com/derikoliveira/dotfiles.git
cd dotfiles
```

Run the installation script:

```bash
chmod +x install.sh
./install.sh
```

## Requirements

Debian/Ubuntu-based system

## Notes

You can safely re-run the install script anytime.

## Testing

For a "fresh" test docker can be used:

```bash
docker rm -f ubuntu_test_1 >/dev/null 2>&1 || true && docker build . -t ubuntu_test:latest && docker run -it --rm --name ubuntu_test_1 ubuntu_test
``
