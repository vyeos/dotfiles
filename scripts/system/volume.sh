#!/usr/bin/env bash

# Define a tag so notifications stack (replace each other)
msgTag="myvolume"

# Handle Arguments
if [[ "$1" == "up" ]]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
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
    # Show Progress Bar (-h int:value:...)
    notify-send -a "Volume" -u low -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$volume" "Volume" "Level: ${volume}%"
fi
