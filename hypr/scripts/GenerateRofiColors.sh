#!/usr/bin/env bash
# Regenerates hypr/rofi/colors.rasi from style/style.json (shared with hyprland.lua and qs/theme/Palette.qml).
# rasi variable names can't contain underscores, so snake_case style.json keys get kebab-cased.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STYLE_JSON="$REPO_DIR/style/style.json"
OUT="$REPO_DIR/hypr/rofi/colors.rasi"

TMP="$OUT.tmp"

# style.json supports // and /* */ comments (JSONC); jq needs them stripped first
python3 "$REPO_DIR/style/lib/strip_jsonc.py" <"$STYLE_JSON" | jq -r '
  .color as $c |
  ($c | to_entries | map("  \(.key | gsub("_"; "-")): #\(.value);") | join("\n")) as $rawColors |
  "* {\n" +
  "  /* friendly aliases used throughout the rofi configs */\n" +
  "  background-color: #" + $c.background + ";\n" +
  "  background-alt:   #" + $c.background_light + ";\n" +
  "  foreground:       #" + $c.text + ";\n" +
  "  selected:         #" + $c.active + ";\n" +
  "  border-color:     #" + $c.border + ";\n" +
  "\n" +
  "  /* every color key from style.json, verbatim */\n" +
  $rawColors + "\n" +
  "\n" +
  "  /* non-color style.json values, as px distances */\n" +
  "  font-family: \"" + .font.family + "\";\n" +
  "  font-size: " + (.font.size | tostring) + ";\n" +
  "  radius: " + (.radius | tostring) + "px;\n" +
  "  gap: " + (.spacing.gap | tostring) + "px;\n" +
  "  padding: " + (.spacing.padding | tostring) + "px;\n" +
  "\n" +
  "  /* combined font string, applied by default in every rofi config that imports this file */\n" +
  "  font: \"" + .font.family + " " + (.font.size | tostring) + "\";\n" +
  "}"
' >"$TMP"

mv "$TMP" "$OUT"
