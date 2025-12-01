#!/usr/bin/env bash

SAVE_DIR="$HOME/Pictures/Screenshots"

case "$1" in
    "satty")
        # 1. Get selection. If user cancels (Esc), exit immediately.
        # This prevents the script from doing unnecessary work.
        geometry=$(slurp) || exit 0

        # 2. Prepare environment only after confirmation
        mkdir -p "$SAVE_DIR"
        filename="$SAVE_DIR/screenshot-$(date +'%Y%m%d-%H%M%S').png"

        # 3. Capture and edit
        # --early-exit: Closes Satty immediately after you copy to clipboard (optional, remove if you dislike it)
        grim -g "$geometry" - | satty --filename - --output-filename "$filename" 
        ;;

    "full")
        # 1. Prepare environment
        mkdir -p "$SAVE_DIR"
        filename="$SAVE_DIR/screenshot-$(date +'%Y%m%d-%H%M%S').png"

        # 2. Take shot
        grim "$filename" && \
        notify-send -u low -i "$filename" "Screenshot" "Saved Fullscreen"
        ;;
    
    *)
        echo "Usage: $0 {satty|full}"
        exit 1
        ;;
esac
