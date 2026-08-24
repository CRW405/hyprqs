#!/usr/bin/env bash
# Screenshots via grim/slurp. Every mode copies the image to the clipboard
# and saves it under ~/Pictures/Screenshots, then sends a notification with
# actions to open or delete the file.
#
# Trimmed from hypr/bkup/scripts/ScreenShot.sh (JaKooLit-style) - dropped the
# swaync sound-effect hooks and countdown modes this project doesn't use.

set -euo pipefail

PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")"
DIR="$PICTURES_DIR/Screenshots"
FILE="Screenshot_$(date "+%d-%b_%H-%M-%S").png"
PATH_OUT="$DIR/$FILE"

mkdir -p "$DIR"

notify_result() {
  if [[ -e "$PATH_OUT" ]]; then
    resp="$(notify-send -t 8000 -A open=Open -A delete=Delete "Screenshot saved" "$FILE" 2>/dev/null || true)"
    case "$resp" in
    open) xdg-open "$PATH_OUT" & ;;
    delete) rm -f "$PATH_OUT" & ;;
    esac
  else
    notify-send -u low "Screenshot" "Not saved" 2>/dev/null || true
  fi
}

case "${1:-}" in
--now)
  grim - | tee "$PATH_OUT" | wl-copy
  notify_result
  ;;
--area)
  geometry="$(slurp)" || exit 0
  [[ -z "$geometry" ]] && exit 0
  grim -g "$geometry" - | tee "$PATH_OUT" | wl-copy
  notify_result
  ;;
--win)
  geometry="$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
  grim -g "$geometry" - | tee "$PATH_OUT" | wl-copy
  notify_result
  ;;
*)
  echo "usage: $0 [--now|--area|--win]" >&2
  exit 2
  ;;
esac
