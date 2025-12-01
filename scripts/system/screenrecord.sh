#!/usr/bin/env bash

# Variables
VIDEOS_DIR="$HOME/Videos"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$VIDEOS_DIR/recording_$TIMESTAMP.mp4"

# Ensure dir exists
mkdir -p "$VIDEOS_DIR"

# 1. STOP LOGIC: If recording is already running, stop it.
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -SIGINT wf-recorder
    # Wait a split second to ensure file finalizes before notifying
    sleep 0.5
    notify-send "Recording Saved" "File saved to $VIDEOS_DIR"
    exit 0
fi

# 2. START LOGIC
case "$1" in
    "region")
        # Get selection. If user presses Esc, exit immediately.
        GEOMETRY=$(slurp) || exit 0
        
        # Start recording in background (&) and disown so the script exits
        wf-recorder -g "$GEOMETRY" -f "$FILENAME" & disown
        ;;
        
    "full")
        wf-recorder -f "$FILENAME" & disown
        ;;
        
    "audio")
        # Bonus: An option to record with audio (PulseAudio default)
        wf-recorder --audio -f "$FILENAME" & disown
        ;;
        
    *)
        echo "Usage: $0 {region|full|audio}"
        exit 1
        ;;
esac

# Optional: Send a low-priority notification that recording started
# This is useful so you know the keypress actually worked.
# notify-send -u low -t 2000 "Recording Started" "Saving to $FILENAME"
