#!/usr/bin/env bash
# Toggles the standalone Quickshell "overview" config (qs/overview) via IPC,
# starting it first if it isn't already running.
# Ported from hypr/bkup/scripts/OverviewToggle.sh (AGS fallback dropped, unused here).

set -euo pipefail

if pgrep -f "qs -c overview" >/dev/null 2>&1; then
  qs ipc -c overview call overview toggle && exit 0
fi

if command -v qs >/dev/null 2>&1; then
  qs -c overview >/dev/null 2>&1 &
  disown
  sleep 0.6
  qs ipc -c overview call overview toggle && exit 0
fi

notify-send "Overview" "Quickshell overview is not available" -u low 2>/dev/null || true
exit 1
