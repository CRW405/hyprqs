#!/usr/bin/env bash
# Starts the awww (swww-compatible) wallpaper daemon and restores the last
# wallpaper, falling back to the first image in WALLPAPER_DIR if there's
# nothing cached yet (e.g. first run).

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"

# awww's control socket is scoped per Wayland session (it's named after
# $WAYLAND_DISPLAY), so a `pgrep -x awww-daemon` here would wrongly find a
# daemon started by a *different* Hyprland session on another tty and skip
# starting one for this session, leaving this session with no daemon of its
# own. Probe this session's socket directly instead.
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
