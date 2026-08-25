#!/usr/bin/env bash
# Toggles the standalone Quickshell "overview" config (qs/overview) via IPC, starting it if needed.
# Launched by path (-p), not name (-c), so it doesn't need a ~/.config/quickshell/overview symlink.

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
