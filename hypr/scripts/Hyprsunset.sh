#!/usr/bin/env bash

set -euo pipefail

STATE_FILE="$HOME/.cache/.hyprsunset_state"
TARGET_TEMP="${HYPRSUNSET_TEMP:-2500}"
NIGHT_START="${HYPRSUNSET_NIGHT_START:-20:00}"
DAY_START="${HYPRSUNSET_DAY_START:-07:00}"

hm_to_minutes() {
  local hh mm
  IFS=: read -r hh mm <<<"$1"
  echo $((10#$hh * 60 + 10#$mm))
}

now_minutes() {
  echo $((10#$(date +%H) * 60 + 10#$(date +%M)))
}

ensure_state() {
  [[ -f "$STATE_FILE" ]] || echo "off" >"$STATE_FILE"
}

apply_state() {
  local state="$1"

  if pgrep -x hyprsunset >/dev/null 2>&1; then
    pkill -x hyprsunset || true
    sleep 0.2
  fi

  if command -v hyprsunset >/dev/null 2>&1; then
    if [[ "$state" == "on" ]]; then
      nohup hyprsunset -t "$TARGET_TEMP" >/dev/null 2>&1 &
    else
      nohup hyprsunset -i >/dev/null 2>&1 &
    fi
  fi

  echo "$state" >"$STATE_FILE"
}

scheduled_state() {
  local now night day
  now="$(now_minutes)"
  night="$(hm_to_minutes "$NIGHT_START")"
  day="$(hm_to_minutes "$DAY_START")"

  if ((night > day)); then
    ((now >= night || now < day)) && echo on || echo off
  else
    ((now >= night && now < day)) && echo on || echo off
  fi
}

minutes_until_next_boundary() {
  local now night day best=1440 boundary delta
  now="$(now_minutes)"
  night="$(hm_to_minutes "$NIGHT_START")"
  day="$(hm_to_minutes "$DAY_START")"

  for boundary in "$night" "$day"; do
    delta=$(((boundary - now + 1440) % 1440))
    ((delta == 0)) && delta=1440
    ((delta < best)) && best=$delta
  done

  echo "$best"
}

cmd_toggle() {
  ensure_state
  local state
  state="$(cat "$STATE_FILE")"

  if [[ "$state" == "on" ]]; then
    apply_state off
    notify-send -u low "Hyprsunset" "Disabled until next schedule change" || true
  else
    apply_state on
    notify-send -u low "Hyprsunset" "Enabled @ ${TARGET_TEMP}K until next schedule change" || true
  fi
}

cmd_auto() {
  while true; do
    ensure_state
    local target current
    target="$(scheduled_state)"
    current="$(cat "$STATE_FILE")"
    [[ "$target" != "$current" ]] && apply_state "$target"

    sleep "$(($(minutes_until_next_boundary) * 60 + 5))"
  done
}

case "${1:-}" in
toggle) cmd_toggle ;;
auto) cmd_auto ;;
*)
  echo "usage: $0 [toggle|auto]" >&2
  exit 2
  ;;
esac
