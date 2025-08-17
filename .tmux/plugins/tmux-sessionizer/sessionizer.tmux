#!/usr/bin/env bash

# Directories to scan (customize this)
dirs=(~/Documents/Code_Projects)

# If a directory was passed as an argument, use that
if [[ -n "$1" ]]; then
  selected=$1
else
  # Otherwise, pick with fzf
  selected=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
fi

# If nothing selected, just exit
if [[ -z "$selected" ]]; then
  exit 0
fi

# Session name is folder name (replace weird chars with "_")
selected_name=$(basename "$selected" | tr . _)

# If tmux isn't running, start new session
if [[ -z "$TMUX" ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

# If session exists, attach/switch; otherwise create new
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
