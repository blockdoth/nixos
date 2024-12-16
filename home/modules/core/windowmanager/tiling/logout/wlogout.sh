#!/usr/bin/env bash

LOCK_FILE="/tmp/wlogout.lock"

cleanup() {
    rm -f "$LOCK_FILE"
}
trap cleanup EXIT

if [ -e "$LOCK_FILE" ]; then
    exit 1
fi

(
  set -C; # Prevents overwritting
  echo "$$" > "$LOCK_FILE"
) 2>/dev/null
if [ $? -ne 0 ]; then
    exit 1
fi

wlogout -b 5
