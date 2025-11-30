#!/bin/bash

# Variables
VIDEOS_DIR="$HOME/Videos"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$VIDEOS_DIR/recording_$TIMESTAMP.mp4"

# Ensure dir exists
mkdir -p "$VIDEOS_DIR"

# Check if running
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -SIGINT wf-recorder
    # Keep this one so you know the file saved
    notify-send "Recording Saved" "File saved to $VIDEOS_DIR"
else
    if [ "$1" == "region" ]; then
        GEOMETRY=$(slurp)
        if [ -z "$GEOMETRY" ]; then exit; fi
        # No "Started" notification here anymore
        wf-recorder -g "$GEOMETRY" -f "$FILENAME"
    else
        # No "Started" notification here anymore
        wf-recorder -f "$FILENAME"
    fi
fi
