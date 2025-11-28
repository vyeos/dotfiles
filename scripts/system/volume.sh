#!/usr/bin/env bash

# Define a tag so notifications stack
msgTag="myvolume"
# Your Theme Green (Sage/Light Green)
THEME_COLOR="#a3be8c"

# Handle Arguments
if [[ "$1" == "up" ]]; then
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
elif [[ "$1" == "down" ]]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
elif [[ "$1" == "mute" ]]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi

# Get current Volume
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep "MUTED")

if [[ -n "$is_muted" ]]; then
    # Show "Muted" notification
    notify-send -a "Volume" -u low -h string:x-dunst-stack-tag:$msgTag "Volume" "Muted"
else
    # Show Progress Bar with COLORED Text
    # We wrap the ${volume}% in a span with the hex code
    notify-send -a "Volume" -u low -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$volume" "Volume" "Level: <span foreground='$THEME_COLOR' weight='bold'>${volume}%</span>"
fi
