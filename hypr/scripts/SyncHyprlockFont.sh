#!/usr/bin/env bash
# Syncs hyprlock.conf's $font variable from style/style.json (font.family) before hyprlock launches.
# hyprlock.conf isn't templated like colors.rasi - this rewrites just the one $font line in place.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STYLE_JSON="$REPO_DIR/style/style.json"
HYPRLOCK_CONF="$REPO_DIR/hypr/hyprlock.conf"

FONT_FAMILY="$(python3 "$REPO_DIR/style/lib/strip_jsonc.py" <"$STYLE_JSON" | jq -r '.font.family')"

sed -i "s/^\$font = .*/\$font = $FONT_FAMILY/" "$HYPRLOCK_CONF"
