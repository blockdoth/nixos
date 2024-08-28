
STATE_FILE="$HOME/waybar/mediaplayer-inputswitcher.state"
SELECTED_INDEX=$(cat $STATE_FILE)p 
echo $SELECTED_INDEX
SELECTED_PLAYER=$(playerctl -l | sed -n $SELECTED_INDEX)


PLAYER_ICON=""
if [[ $SELECTED_PLAYER == *"firefox"* ]]; then
  PLAYER_ICON="󰈹"
elif [[ $SELECTED_PLAYER == *"spotify"* ]]; then
  PLAYER_ICON=""
fi

STATUS=$(playerctl metadata --player=$SELECTED_PLAYER --format '{{lc(status)}}')
STATE_ICON=""
if [[ $STATUS == "playing" ]]; then
  STATE_ICON=""
fi


METADATA=$(playerctl metadata --player=$SELECTED_PLAYER --format '{{artist}} - {{title}}')
if [[ ''${#METADATA} > 40 ]]; then
  METADATA=$(echo $METADATA | cut -c1-40)"..."
fi

echo "<span font='15' rise='-2pt'>$PLAYER_ICON $STATE_ICON</span> $METADATA |"