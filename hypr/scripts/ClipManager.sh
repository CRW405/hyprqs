#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROFI_THEME="$SCRIPT_DIR/../rofi/config-clipboard.rasi"
THUMB_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist-thumbs"

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

mkdir -p "$THUMB_DIR"
find "$THUMB_DIR" -type f -mmin +60 -delete 2>/dev/null || true

build_entries() {
  while IFS=$'\t' read -r id preview; do
    line="$id"$'\t'"$preview"
    if [[ "$preview" == "[[ binary data"*"]]" ]]; then
      thumb="$THUMB_DIR/$id"
      if [[ ! -e "$thumb" ]]; then
        cliphist decode <<<"$line" >"$thumb.tmp" 2>/dev/null && mv "$thumb.tmp" "$thumb" || rm -f "$thumb.tmp"
      fi
      if [[ -s "$thumb" ]] && file --mime-type -b "$thumb" | grep -q '^image/'; then
        printf '%s\0icon\x1f%s\n' "$line" "$thumb"
        continue
      fi
    fi
    printf '%s\n' "$line"
  done < <(cliphist list)
}

while true; do
  entry="$(build_entries | rofi -dmenu -i -show-icons -p "Clipboard" \
    -config "$ROFI_THEME" \
    -mesg "Enter: copy ||| Delete: Ctrl+Delete entry ||| Alt+Delete: wipe all" \
    -kb-custom-1 "Control+Delete" \
    -kb-custom-2 "Alt+Delete")" && code=0 || code=$?

  case "$code" in
  1)
    exit 0
    ;;
  10)
    [ -n "$entry" ] && cliphist delete <<<"$entry"
    continue
    ;;
  11)
    cliphist wipe
    wl-copy --clear
    rm -f "$THUMB_DIR"/*
    notify-send "Clipboard" "History wiped" -u low 2>/dev/null || true
    exit 0
    ;;
  0)
    [ -z "$entry" ] && exit 0
    cliphist decode <<<"$entry" | wl-copy
    exit 0
    ;;
  esac
done
