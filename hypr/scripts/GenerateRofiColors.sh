#!/usr/bin/env bash
# Regenerates hypr/rofi/colors.rasi from the central style/style.json so
# every rofi menu (launcher, search, wallpaper picker) stays in sync with one
# source of truth shared with hyprland.lua (style/style.lua) and the
# quickshell bar (qs/theme/Palette.qml). Meant to be run right before
# launching rofi, since it's cheap and guarantees fresh colors even if
# style.json changed since the last Hyprland reload.
#
# Emits every key from style.json's "color" object as a @key rasi variable
# (not just a curated subset), plus font/radius/spacing, so any variable
# added to style.json is automatically available as @key in every .rasi
# file without this script needing to be updated. A handful of friendly
# aliases (background-color, background-alt, foreground, selected,
# border-color) are kept on top for readability in the existing configs.
#
# rasi property/variable names can't contain underscores (rofi's parser
# rejects them with "invalid property name"), so snake_case style.json
# keys like text_dark are kebab-cased to text-dark here.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STYLE_JSON="$REPO_DIR/style/style.json"
OUT="$REPO_DIR/hypr/rofi/colors.rasi"

TMP="$OUT.tmp"

jq -r '
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
  "  /* non-color style.json values. radius/gap/padding are emitted as\n" +
  "     px distances (not bare numbers) so they can be used directly in\n" +
  "     border-radius/padding/spacing/margin properties. */\n" +
  "  font-family: \"" + .font.family + "\";\n" +
  "  font-size: " + (.font.size | tostring) + ";\n" +
  "  radius: " + (.radius | tostring) + "px;\n" +
  "  gap: " + (.spacing.gap | tostring) + "px;\n" +
  "  padding: " + (.spacing.padding | tostring) + "px;\n" +
  "\n" +
  "  /* combined font string, and applied directly here so every widget in\n" +
  "     any rofi config that imports this file gets it by default (same\n" +
  "     mechanism as the color aliases above) */\n" +
  "  font: \"" + .font.family + " " + (.font.size | tostring) + "\";\n" +
  "}"
' "$STYLE_JSON" >"$TMP"

mv "$TMP" "$OUT"
