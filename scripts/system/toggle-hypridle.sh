#!/usr/bin/env bash

if [[ "$1" == "on" ]]; then
  # Only start if not already running
  if ! pgrep -x "hypridle" < /dev/null; then
    hypridle &
    notify-send -u low "Hypridle" "Enabled (Auto-Lock ON)"
  fi

elif [[ "$1" == "off" ]]; then
  # Kill process (2>/dev/null hides error if it wasn't running)
  if pgrep -x "hypridle" > /dev/null; then
    killall hypridle 2>/dev/null
    notify-send -u low "Hypridle" "Disabled (Caffeine Mode)"
  fi
fi
