#!/usr/bin/env bash

# Usage: ./audio_control.sh [speaker|mic|toggle-speaker|toggle-mic|vol-up|vol-down]

STATE_FILE="/tmp/mic_last_state"
COLOR_ACCENT="#ffb86c"

# --- HELPER FUNCTIONS ---

get_status() {
    local STATUS=$(wpctl get-volume $1)
    if [[ $STATUS == *"[MUTED]"* ]]; then
        echo "muted"
    else
        echo "unmuted"
    fi
}

send_osd() {
    # Helper to send the Amber Sevastopol Notification
    local VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
    dunstify -r 1001 \
             -a "OSD" \
             -h int:value:"$VAL" \
             "Volume" \
             "Level: <span foreground='$COLOR_ACCENT' font_weight='bold'>${VAL}%</span>"
}

# --- MAIN LOGIC ---

case $1 in
    "speaker")
        # Waybar Module Logic
        VOL_STR=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
        if [[ $VOL_STR == *"[MUTED]"* ]]; then
            printf '{"text": "AUD: MUTE", "class": "muted", "alt": "muted"}\n'
        else
            VOL=$(echo "$VOL_STR" | awk '{print int($2 * 100)}')
            printf '{"text": "AUD: %s%%", "class": "unmuted", "alt": "unmuted"}\n' "$VOL"
        fi
        ;;

    "mic")
        # Waybar Module Logic
        VOL_STR=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
        if [[ $VOL_STR == *"[MUTED]"* ]]; then
            printf '{"text": "MIC: MUTE", "class": "muted"}\n'
        else
            printf '{"text": "MIC: ON", "class": "unmuted"}\n'
        fi
        ;;

    "toggle-speaker")
        # Toggle Logic: Mute All / Restore Mic
        SINK_STATUS=$(get_status @DEFAULT_AUDIO_SINK@)
        MIC_STATUS=$(get_status @DEFAULT_AUDIO_SOURCE@)

        if [ "$SINK_STATUS" == "unmuted" ]; then
            # Muting
            if [ "$MIC_STATUS" == "muted" ]; then echo "1" > "$STATE_FILE"; else echo "0" > "$STATE_FILE"; fi
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
            wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
            dunstify -r 1001 -a "OSD" "Volume" "System <span foreground='#ff5555'>MUTED</span>"
        else
            # Unmuting
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
            # Restore Mic
            if [ -f "$STATE_FILE" ]; then
                LAST_STATE=$(cat "$STATE_FILE")
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ "$LAST_STATE"
            else
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
            fi
            send_osd
        fi
        ;;

    "toggle-mic")
        # Blocking Logic: Cannot toggle if Speaker Muted
        SINK_STATUS=$(get_status @DEFAULT_AUDIO_SINK@)
        if [ "$SINK_STATUS" == "muted" ]; then
            notify-send -u critical "Sevastopol Audio" "Cannot enable Mic while System Audio is Muted."
        else
            wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        fi
        ;;

    "vol-up")
        # --- NEW BLOCKING LOGIC ---
        SINK_STATUS=$(get_status @DEFAULT_AUDIO_SINK@)
        if [ "$SINK_STATUS" == "muted" ]; then
            dunstify -r 1001 -u low "Volume Locked" "<span foreground='#ff5555'>Speakers are MUTED</span>"
        else
            wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
            send_osd
        fi
        ;;

    "vol-down")
        # --- NEW BLOCKING LOGIC ---
        SINK_STATUS=$(get_status @DEFAULT_AUDIO_SINK@)
        if [ "$SINK_STATUS" == "muted" ]; then
             dunstify -r 1001 -u low "Volume Locked" "<span foreground='#ff5555'>Speakers are MUTED</span>"
        else
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            send_osd
        fi
        ;;
esac
