#!/usr/bin/env bash

# file to save the input state
STATE_FILE="$HOME/waybar/mediaplayer-inputswitcher.state"    

# create dir if it not exists 
mkdir -p "$(dirname "$STATE_FILE")"

# set default state if state file doesnt exist
if [ ! -f "$STATE_FILE" ]; then
  echo "0" > "$STATE_FILE"  
fi

CURRENT_SOURCE=$(cat "$STATE_FILE")
NUM_SOURCES=$(playerctl -l | wc -l)

if [[ $NUM_SOURCES == "0" ]]; then
  echo "0" > "$STATE_FILE" 
else
  echo $(((CURRENT_SOURCE % NUM_SOURCES) + 1)) > "$STATE_FILE"
fi


echo $(cat "$STATE_FILE") 
