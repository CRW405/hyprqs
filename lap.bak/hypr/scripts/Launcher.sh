#!/usr/bin/env bash
# Opens the main app launcher (drun/run/window), first regenerating
# hypr/rofi/colors.rasi so it reflects the current style/style.json.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/GenerateRofiColors.sh"

if pidof rofi >/dev/null 2>&1; then
  pkill rofi
  exit 0
fi

exec rofi -show drun -modi drun,run,window -config "$SCRIPT_DIR/../rofi/config-launcher.rasi"
