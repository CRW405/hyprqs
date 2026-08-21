#!/usr/bin/env bash

set -euo pipefail

SEARCH_ENGINE="${SEARCH_ENGINE:-https://duckduckgo.com/}"
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

query="$(rofi -dmenu -p "Search" -config "$SCRIPT_DIR/../rofi/config-search.rasi")"

[[ -z "$query" ]] && exit 0

encoded_query="$(jq -sRr @uri <<<"$query")"
xdg-open "${SEARCH_ENGINE}${encoded_query}" >/dev/null 2>&1 &
