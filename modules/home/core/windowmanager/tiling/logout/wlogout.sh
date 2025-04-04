#!/usr/bin/env bash

LOCK_FILE="/tmp/wlogout.lock"

if [ -e "$LOCK_FILE" ]; then
    exit 0
fi

(
  set -C; # Prevents overwritting
  echo "$$" > "$LOCK_FILE"
) 2>/dev/null

wlogout -b 5

rm -f "$LOCK_FILE"