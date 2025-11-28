#!/usr/bin/env bash

msgTag="mybrightness"

# Change brightness (usage: ./brightness.sh 5%+ or ./brightness.sh 5%-)
brightnessctl set "$1" > /dev/null

# Get current brightness percentage
current=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')

# Send Notification with Progress Bar
notify-send -a "Backlight" -u low -h string:x-dunst-stack-tag:$msgTag \
-h int:value:"$current" "Brightness" "Level: ${current}%"
