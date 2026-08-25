#!/usr/bin/env bash
# Starts the awww wallpaper daemon and restores the last wallpaper, falling back
# to the first image in WALLPAPER_DIR on first run.

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"

# probe this session's awww socket directly - pgrep would also match a daemon
# started by a different Hyprland session on another tty
if ! awww query >/dev/null 2>&1; then
  awww-daemon >/dev/null 2>&1 &
  disown
  sleep 0.5
fi

if awww restore 2>/dev/null; then
  exit 0
fi

first="$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) | sort | head -n1)"

if [ -n "$first" ]; then
  awww img "$first"
fi
