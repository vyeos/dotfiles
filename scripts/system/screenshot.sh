#!/usr/bin/env bash

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

if [ "$1" == "swappy" ]; then
    # 1. Get selection
    geometry=$(slurp)
    
    # 2. If user selected something (didn't press Esc during selection)
    if [ -n "$geometry" ]; then
        # Capture and pipe to swappy
        # Swappy handles the saving/closing now via ~/.config/swappy/config
        grim -g "$geometry" - | swappy -f -
    fi

elif [ "$1" == "full" ]; then
    # 1. Define filename
    filename="$SAVE_DIR/screenshot-$(date +'%Y%m%d-%H%M%S').png"
    
    # 2. Take shot
    grim "$filename"
    
    # 3. Notify with image preview (Only for fullscreen, which is silent otherwise)
    notify-send -u low -i "$filename" "Screenshot" "Saved Fullscreen"
fi
