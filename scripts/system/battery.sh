#!/usr/bin/env bash

BATTERY="macsmc-battery"
POWER_PATH="/sys/class/power_supply/$BATTERY"

# Initialize state to avoid false notifications on startup
last_status=$(cat "$POWER_PATH/status" 2>/dev/null)
warned=false

while true; do
    # Read current data (silencing errors)
    current_status=$(cat "$POWER_PATH/status" 2>/dev/null)
    capacity=$(cat "$POWER_PATH/capacity" 2>/dev/null)

    # 1. Plug-in Detection
    # If status changed to Charging, send message and reset the warning flag
    if [[ "$current_status" == "Charging" && "$last_status" != "Charging" ]]; then
        notify-send -u low "Power" "Charger Connected"
        warned=false
    fi

    # 2. Low Battery Warning
    # Only warn if discharging, <= 10%, and we haven't warned recently
    if [[ "$current_status" == "Discharging" && "$capacity" -le 10 && "$warned" == "false" ]]; then
        notify-send -u critical "Battery Low" "${capacity}% remaining"
        warned=true
    fi

    # Reset warning flag if battery recovers above 10%
    if [[ "$capacity" -gt 10 ]]; then
        warned=false
    fi

    # Update history and wait
    last_status=$current_status
    sleep 5
done
