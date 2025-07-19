#!/bin/bash

# Tmux Session Switcher
# Uses zoxide to interactively select a directory, then creates/switches to a
# tmux session
# - If not in tmux: creates and attaches to session
# - If in tmux: creates session (if needed) and switches to it (no nesting)

if [[ "$1" == "-i" ]]; then
    shift  # Remove -i from arguments
    path=$(zoxide query -i "$@")
else
    path=$(zoxide query "$@")
fi

dir=$(basename "$path")

# Check if we're already in tmux
if [ -n "$TMUX" ]; then
    # We're in tmux - create session if it doesn't exist, then switch to it
    tmux new-session -d -s "$dir" -c "$path" 2>/dev/null || true
    tmux switch-client -t "$dir"
else
    # We're not in tmux - create and attach
    tmux new-session -A -s "$dir" -c "$path"
fi

