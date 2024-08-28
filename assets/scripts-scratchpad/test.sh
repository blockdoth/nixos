#!/usr/bin/env bash

# file to save the input state
STATE_FILE="$HOME/waybar/mediaplayer-inputswitcher.state"    

# create dir if it not exists 
mkdir -p "$(dirname "$STATE_FILE")"

# set default state if state file doesnt exist
if [ ! -f "$STATE_FILE" ]; then
  echo "1" > "$STATE_FILE"  
fi

current_source=$(cat "$STATE_FILE")
num_sources=$(playerctl -l | wc -l)

echo $(((current_source) % (num_sources) + 1)) > "$STATE_FILE"

echo $(cat "$STATE_FILE") 
