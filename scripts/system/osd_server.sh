#!/usr/bin/env bash

# SEVASTOPOL OSD SERVER (Audio & Brightness + Persistence)
# Usage: ./osd_server.sh [vol-up|vol-down|toggle-speaker|bri+|bri-|restore]

# --- CONFIG ---
COLOR_ACCENT="#ffb86c" # Amber
MIC_STATE_FILE="/tmp/mic_last_state"
VOL_STATE_FILE="/home/vyeos/.cache/volume_last_state" # Persistent storage

# --- HELPERS ---

get_vol_status() {
    local STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if [[ $STATUS == *"[MUTED]"* ]]; then echo "muted"; else echo "unmuted"; fi
}

get_mic_status() {
    local STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
    if [[ $STATUS == *"[MUTED]"* ]]; then echo "muted"; else echo "unmuted"; fi
}

save_volume() {
    # Save current volume integer to file
    local VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
    echo "$VAL" > "$VOL_STATE_FILE"
}

send_notification() {
    TITLE=$1
    VALUE=$2
    ICON=$3
    ID=$4

    dunstify -r "$ID" \
             -a "OSD" \
             -i "$ICON" \
             -h int:value:"$VALUE" \
             "$TITLE" \
             "Level: <span foreground='$COLOR_ACCENT' font_weight='bold'>${VALUE}%</span>"
}

# --- MAIN LOGIC ---

case $1 in
    # --- RESTORE LOGIC (Run on Startup/Wake) ---
    "restore")
        if [ -f "$VOL_STATE_FILE" ]; then
            LAST_VOL=$(cat "$VOL_STATE_FILE")
            # Ensure it's a valid number, otherwise default to 30% safety
            if [[ "$LAST_VOL" =~ ^[0-9]+$ ]]; then
                wpctl set-volume @DEFAULT_AUDIO_SINK@ "${LAST_VOL}%"
            else
                wpctl set-volume @DEFAULT_AUDIO_SINK@ 30%
            fi
        fi
        ;;

    # --- BRIGHTNESS CONTROLS ---
    "bri+")
        brightnessctl s 5%+ -q
        VAL=$(brightnessctl i | grep -oP '\d+%' | head -n1 | tr -d '%')
        send_notification "Brightness" "$VAL" "display-brightness-high" 1002
        ;;
    "bri-")
        brightnessctl s 5%- -q
        VAL=$(brightnessctl i | grep -oP '\d+%' | head -n1 | tr -d '%')
        send_notification "Brightness" "$VAL" "display-brightness-low" 1002
        ;;

    # --- AUDIO CONTROLS ---
    "vol-up")
        if [ "$(get_vol_status)" == "muted" ]; then
            dunstify -r 1001 -u low "Volume Locked" "<span foreground='#ff5555'>Speakers are MUTED</span>"
        else
            wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
            save_volume # <--- SAVE STATE
            VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
            send_notification "Volume" "$VAL" "audio-volume-high" 1001
        fi
        ;;
    "vol-down")
        if [ "$(get_vol_status)" == "muted" ]; then
            dunstify -r 1001 -u low "Volume Locked" "<span foreground='#ff5555'>Speakers are MUTED</span>"
        else
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            save_volume # <--- SAVE STATE
            VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
            send_notification "Volume" "$VAL" "audio-volume-low" 1001
        fi
        ;;
    "toggle-speaker")
        if [ "$(get_vol_status)" == "unmuted" ]; then
            # Muting
            if [ "$(get_mic_status)" == "muted" ]; then echo "1" > "$MIC_STATE_FILE"; else echo "0" > "$MIC_STATE_FILE"; fi
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
            wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
            dunstify -r 1001 -a "OSD" -i "audio-volume-muted" "Volume" "System <span foreground='#ff5555'>MUTED</span>"
        else
            # Unmuting
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
            if [ -f "$MIC_STATE_FILE" ]; then
                LAST_STATE=$(cat "$MIC_STATE_FILE")
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ "$LAST_STATE"
            else
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
            fi
            
            # Show OSD and Restore correct volume level just in case
            save_volume # <--- SAVE STATE (to ensure current unmuted level is captured)
            VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
            send_notification "Volume" "$VAL" "audio-volume-high" 1001
        fi
        ;;
esac
