#!/usr/bin/env bash
# Opens the main app launcher (drun/run/window), first regenerating
# hypr/rofi/colors.rasi so it reflects the current style/style.json.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/GenerateRofiColors.sh"

if pidof rofi >/dev/null 2>&1; then
  pkill rofi
  for _ in 1 2 3 4 5; do
    pidof rofi >/dev/null 2>&1 || break
    sleep 0.1
  done
  pidof rofi >/dev/null 2>&1 && pkill -9 rofi
  exit 0
fi

exec rofi -show drun -modi drun,run,window -config "$SCRIPT_DIR/../rofi/config-launcher.rasi"
