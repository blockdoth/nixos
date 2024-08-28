STATE_FILE="$HOME/waybar/mediaplayer-inputswitcher.state"
SELECTED_INDEX=$(cat $STATE_FILE)p 
SELECTED_PLAYER=$(playerctl -l | sed -n $SELECTED_INDEX)
playerctl --player=$SELECTED_PLAYER play-pause