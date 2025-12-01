#!/bin/bash

# REPLACE THIS with your actual device name found in step 2
DEVICE="kbd_backlight"

# Check if the slider is already open; if so, close it (toggle behavior)
if pgrep -f "yad --scale --title=kbd_brightness_slider" > /dev/null; then
    pkill -f "yad --scale --title=kbd_brightness_slider"
    exit 0
fi

# Get current and max brightness
curr=$(brightnessctl -d "$DEVICE" g)
max=$(brightnessctl -d "$DEVICE" m)

# Calculate current percentage for the prompt (optional)
perc=$(( 100 * curr / max ))

# Open YAD slider
# --print-partial: allows the value to update as you drag, not just when you release
yad --scale \
    --min-value=0 \
    --max-value="$max" \
    --value="$curr" \
    --print-partial \
    --title="kbd_brightness_slider" \
    --width=250 --height=30 \
    --button="Close:1" \
    --undecorated \
    --fixed \
    --close-on-unfocus \
    --mouse \
    | while read -r val; do
        # Only update if val is a number (yad sometimes outputs other strings on exit)
        if [[ "$val" =~ ^[0-9]+$ ]]; then
            brightnessctl -d "$DEVICE" s "$val" -q
        fi
    done
