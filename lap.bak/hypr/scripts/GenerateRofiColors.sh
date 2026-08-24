#!/usr/bin/env bash
# Regenerates hypr/rofi/colors.rasi from the central style/style.json so
# every rofi menu (launcher, wallpaper picker) stays in sync with one
# source of truth shared with hyprland.lua (style/style.lua) and the
# quickshell bar (qs/theme/Palette.qml). Meant to be run right before
# launching rofi, since it's cheap and guarantees fresh colors even if
# style.json changed since the last Hyprland reload.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STYLE_JSON="$REPO_DIR/style/style.json"
OUT="$REPO_DIR/hypr/rofi/colors.rasi"

jq -r '
  .color as $c |
  "* {\n" +
  "  background-color: #" + $c.background + ";\n" +
  "  background-alt:   #" + $c.background_light + ";\n" +
  "  foreground:       #" + $c.text + ";\n" +
  "  selected:         #" + $c.active + ";\n" +
  "  border-color:     #" + $c.border + ";\n" +
  "}"
' "$STYLE_JSON" >"$OUT"
