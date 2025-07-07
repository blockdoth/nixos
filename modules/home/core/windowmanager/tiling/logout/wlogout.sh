#!/usr/bin/env bash

# Check if wlogout is already running
if pidof wlogout >/dev/null; then
    exit 0
fi

wlogout -b 5

