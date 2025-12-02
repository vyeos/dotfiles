#!/usr/bin/env bash

# Content will be "1" (Muted) or "0" (Unmuted)
STATE_FILE="/tmp/mic_last_state"

get_status() {
    # Returns "muted" or "unmuted" based on the target (@SINK@ or @SOURCE@)
    local STATUS=$(wpctl get-volume $1)
    if [[ $STATUS == *"[MUTED]"* ]]; then
        echo "muted"
    else
        echo "unmuted"
    fi
}

case $1 in
    "speaker")
        # --- DISPLAY LOGIC (Same as before) ---
        VOL_STR=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
        if [[ $VOL_STR == *"[MUTED]"* ]]; then
            TEXT="AUD: MUTE"
            CLASS="muted"
            ALT="muted"
        else
            VOL=$(echo "$VOL_STR" | awk '{print int($2 * 100)}')
            TEXT="AUD: ${VOL}%"
            CLASS="unmuted"
            ALT="unmuted"
        fi
        printf '{"text": "%s", "class": "%s", "alt": "%s"}\n' "$TEXT" "$CLASS" "$ALT"
        ;;

    "mic")
        # --- DISPLAY LOGIC (Same as before) ---
        VOL_STR=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
        if [[ $VOL_STR == *"[MUTED]"* ]]; then
            TEXT="MIC: MUTE"
            CLASS="muted"
        else
            TEXT="MIC: ON"
            CLASS="unmuted"
        fi
        printf '{"text": "%s", "class": "%s"}\n' "$TEXT" "$CLASS"
        ;;

    "toggle-speaker")
        # --- SMART LOGIC ---
        SINK_STATUS=$(get_status @DEFAULT_AUDIO_SINK@)
        MIC_STATUS=$(get_status @DEFAULT_AUDIO_SOURCE@)

        if [ "$SINK_STATUS" == "unmuted" ]; then
            # CASE: Muting the System
            # 1. Save current Mic state to file so we remember it later
            if [ "$MIC_STATUS" == "muted" ]; then
                echo "1" > "$STATE_FILE"
            else
                echo "0" > "$STATE_FILE"
            fi
            
            # 2. Mute BOTH
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
            wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
        else
            # CASE: Unmuting the System
            # 1. Unmute Speaker
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
            
            # 2. Restore Mic State
            if [ -f "$STATE_FILE" ]; then
                LAST_STATE=$(cat "$STATE_FILE")
                # Apply the saved state (0 = Unmute, 1 = Mute)
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ "$LAST_STATE"
            else
                # Default safety: If no file exists, keep mic muted
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
            fi
        fi
        ;;

    "toggle-mic")
        # --- BLOCKING LOGIC ---
        SINK_STATUS=$(get_status @DEFAULT_AUDIO_SINK@)

        if [ "$SINK_STATUS" == "muted" ]; then
            # Case: Speakers are OFF. Block the action.
            # Optional: Send a notification saying why
            notify-send -u low "Sevastopol Audio" "Cannot enable Mic while System Audio is Muted."
        else
            # Case: Speakers are ON. Allow Toggle.
            wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        fi
        ;;
esac
