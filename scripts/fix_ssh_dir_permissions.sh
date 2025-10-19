#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SSH_DIR="${1:-$HOME/.ssh/}"

if [[ ! -d "$SSH_DIR" ]]; then
    echo "Directory not found: $SSH_DIR";
    exit 1
fi

chmod -v 700 "$SSH_DIR"
find "$SSH_DIR" -maxdepth 1 -type f -name 'id_*' ! -name '*.pub' -print0 | xargs -0r chmod -v 600
find "$SSH_DIR" -maxdepth 1 -type f -name 'id_*.pub' -print0 | xargs -0r chmod -v 644
