#!/usr/bin/env bash
# Lets you pick a wallpaper from WALLPAPER_DIR via rofi (grid of thumbnails,
# styled after an older JaKooLit-based rofi wallpaper picker, see
# ../rofi/config-wallpaper.rasi) and applies it through awww (swww-compatible)
# with a short transition, targeting whichever display currently has focus so
# each monitor can have its own wallpaper.

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROFI_THEME="$SCRIPT_DIR/../rofi/config-wallpaper.rasi"

# Keep hypr/rofi/colors.rasi in sync with style/style.json before launching.
"$SCRIPT_DIR/GenerateRofiColors.sh"

if [ ! -d "$WALLPAPER_DIR" ]; then
  notify-send "Wallpaper" "Directory not found: $WALLPAPER_DIR" -u low 2>/dev/null || true
  exit 1
fi

mapfile -t files < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) | sort)

if [ "${#files[@]}" -eq 0 ]; then
  notify-send "Wallpaper" "No images found in $WALLPAPER_DIR" -u low 2>/dev/null || true
  exit 1
fi

output="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"

# Scale the thumbnail size to the focused display (same formula the old
# config used) so the grid looks right on both hi-DPI and low-res monitors.
icon_size=20
if [ -n "$output" ]; then
  read -r mon_height mon_scale < <(hyprctl monitors -j | jq -r --arg mon "$output" '.[] | select(.name == $mon) | "\(.height) \(.scale)"')
  if [ -n "${mon_height:-}" ] && [ -n "${mon_scale:-}" ]; then
    icon_size="$(echo "scale=1; ($mon_height * 3) / ($mon_scale * 150)" | bc)"
    icon_size="$(awk -v s="$icon_size" 'BEGIN { if (s < 15) s = 20; if (s > 25) s = 25; print s }')"
  fi
fi

entries=""
for f in "${files[@]}"; do
  entries+="$(basename "$f")\0icon\x1fthumbnail://${f}\n"
done

choice="$(printf "%b" "$entries" | rofi -dmenu -show-icons -p "Wallpaper" \
  -config "$ROFI_THEME" \
  -theme-str "element-icon { size: ${icon_size}%; }")"

[ -z "$choice" ] && exit 0

output_args=()
[ -n "$output" ] && output_args=(-o "$output")

awww img "$WALLPAPER_DIR/$choice" \
  "${output_args[@]}" \
  --transition-type grow \
  --transition-pos center \
  --transition-duration 1
