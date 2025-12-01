#!/usr/bin/env bash

SAVE_DIR="$HOME/Pictures/Screenshots"

case "$1" in
    "satty")
        # 1. Get selection. If user cancels (Esc), exit immediately.
        geometry=$(slurp) || exit 0

        # 2. Prepare environment
        mkdir -p "$SAVE_DIR"
        filename="$SAVE_DIR/screenshot-$(date +'%Y%m%d-%H%M%S').png"

        # 3. Capture and edit
        grim -g "$geometry" - | satty --filename - --output-filename "$filename" 
        ;;

    "full")
        # 1. Prepare environment
        mkdir -p "$SAVE_DIR"
        filename="$SAVE_DIR/screenshot-$(date +'%Y%m%d-%H%M%S').png"

        # 2. Take shot and pipe to Satty
        # We use '-' with grim to output to stdout, then pipe to satty
        grim - | satty --filename - --output-filename "$filename"
        
        # 3. (Optional) Notify ONLY if the user actually saved the file in Satty
        if [ -f "$filename" ]; then
            notify-send -u low -i "$filename" "Screenshot" "Saved Fullscreen"
        fi
        ;;
    
    *)
        echo "Usage: $0 {satty|full}"
        exit 1
        ;;
esac
