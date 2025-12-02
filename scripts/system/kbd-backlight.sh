#!/usr/bin/env bash

# DEVICE CONFIG
DEVICE="kbd_backlight"
SYS_PATH="/sys/class/leds/$DEVICE"
STATE_FILE="/tmp/kbd_backlight_last"
ICON="input-keyboard"

# --- ROBUST GET FUNCTIONS ---

get_current() {
    # Try brightnessctl first
    VAL=$(brightnessctl -d "$DEVICE" g 2>/dev/null)
    # If empty, read directly from system file
    if [ -z "$VAL" ]; then
        VAL=$(cat "$SYS_PATH/brightness" 2>/dev/null)
    fi
    # If still empty (device missing?), default to 0
    echo "${VAL:-0}"
}

get_max() {
    VAL=$(brightnessctl -d "$DEVICE" m 2>/dev/null)
    if [ -z "$VAL" ]; then
        VAL=$(cat "$SYS_PATH/max_brightness" 2>/dev/null)
    fi
    # Default to 255 to prevent YAD crash
    echo "${VAL:-255}"
}

# --- LOGIC ---

case "$1" in
    "toggle")
        CURRENT=$(get_current)
        
        if [ "$CURRENT" -gt 0 ]; then
            # TURN OFF
            echo "$CURRENT" > "$STATE_FILE"
            brightnessctl -d "$DEVICE" s 0 -q
            notify-send -u low -i "$ICON" "Keyboard" "Off" -h string:x-canonical-private-synchronous:kbd_notif
        else
            # RESTORE
            if [ -f "$STATE_FILE" ]; then
                LAST=$(cat "$STATE_FILE")
                brightnessctl -d "$DEVICE" s "$LAST" -q
            else
                # Fallback to Max
                MAX=$(get_max)
                brightnessctl -d "$DEVICE" s "$MAX" -q
            fi
            notify-send -u low -i "$ICON" "Keyboard" "On" -h string:x-canonical-private-synchronous:kbd_notif
        fi
        ;;
    *)
        # GUI SLIDER
        
        # 1. Close if already open (Toggle behavior)
        if pgrep -f "yad --scale --class=kbd_slider" > /dev/null; then
            pkill -f "yad --scale --class=kbd_slider"
            exit 0
        fi

        curr=$(get_current)
        max=$(get_max)

        # 2. Launch YAD
        # We force variables to integers for safety
        yad --scale \
            --class="kbd_slider" \
            --title="Keyboard Brightness" \
            --min-value=0 \
            --max-value="$max" \
            --value="$curr" \
            --print-partial \
            --width=200 --height=20 \
            --undecorated \
            --fixed \
            --mouse \
            --close-on-unfocus \
            --no-buttons \
            | while read -r val; do
                if [[ "$val" =~ ^[0-9]+$ ]]; then
                    brightnessctl -d "$DEVICE" s "$val" -q
                fi
            done
        ;;
esac
