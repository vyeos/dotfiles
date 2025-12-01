#!/usr/bin/env bash

# PATHS
WALL_NORMAL="$HOME/Pictures/Wallpapers/Sevastopol_Normal.jpg"
WALL_EMERGENCY="$HOME/Pictures/Wallpapers/Sevastopol_Emergency.jpg"

while true; do
    # Check battery percentage (integer)
    BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    # Current wallpaper check (to avoid reloading every 5 seconds)
    CURRENT=$(swww query | grep -oP "image: \K.*")

    if [ "$BATTERY" -le 20 ] && [ "$STATUS" == "Discharging" ]; then
        if [ "$CURRENT" != "$WALL_EMERGENCY" ]; then
            # EMERGENCY PROTOCOL
            swww img "$WALL_EMERGENCY" --transition-type grow --transition-pos 0.5,0.5 --transition-step 90
            dunstify -u critical "CRITICAL POWER FAILURE" "SEVASTOPOL EMERGENCY PROTOCOL ACTIVE"
            # Optional: Change Hyprland borders to Red
            hyprctl keyword general:col.active_border "rgb(ff5555)"
        fi
    else
        if [ "$CURRENT" != "$WALL_NORMAL" ]; then
            # STANDARD OPERATIONS
            swww img "$WALL_NORMAL" --transition-type fade
            # Reset Hyprland borders to Amber
            hyprctl keyword general:col.active_border "rgb(ffb86c)"
        fi
    fi

    sleep 10
done
