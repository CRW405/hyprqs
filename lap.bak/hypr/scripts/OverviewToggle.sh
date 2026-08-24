#!/usr/bin/env bash
# Toggles the standalone Quickshell "overview" config (qs/overview) via IPC,
# starting it first if it isn't already running.
# Ported from hypr/bkup/scripts/OverviewToggle.sh (AGS fallback dropped, unused here).
#
# Launched by path (-p), not by name (-c), so it doesn't depend on a
# ~/.config/quickshell/overview symlink -- matches how basicBar.qml is
# launched from hyprland.lua.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
overview_dir="$(cd "$script_dir/../../qs/overview" && pwd)"

if pgrep -f "qs -p $overview_dir" >/dev/null 2>&1; then
  qs ipc -p "$overview_dir" call overview toggle && exit 0
fi

if command -v qs >/dev/null 2>&1; then
  qs -p "$overview_dir" >/dev/null 2>&1 &
  disown
  sleep 0.6
  qs ipc -p "$overview_dir" call overview toggle && exit 0
fi

notify-send "Overview" "Quickshell overview is not available" -u low 2>/dev/null || true
exit 1
