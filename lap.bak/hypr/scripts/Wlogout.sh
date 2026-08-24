#!/usr/bin/env bash

set -euo pipefail

if pgrep -x wlogout >/dev/null 2>&1; then
  pkill -x wlogout
  exit 0
fi

exec wlogout --protocol layer-shell
