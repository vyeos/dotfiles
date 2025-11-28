#!/usr/bin/env bash
if pgrep -x "hypridle" > /dev/null; then
    echo "Hypridle is already running."
else
    hypridle &
    notify-send "Session End"
fi
