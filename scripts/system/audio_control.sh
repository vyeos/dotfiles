#!/usr/bin/env bash

# Optimized audio control with caching to reduce wpctl calls
STATE_FILE="/tmp/mic_last_state"
CACHE_FILE="/tmp/audio_cache"
CACHE_TIMEOUT=1  # 1 second cache

get_cached_status() {
    local target=$1
    local cache_key="${target}_status"
    local current_time=$(date +%s)
    
    if [[ -f "$CACHE_FILE" ]]; then
        local cache_time=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
        if (( current_time - cache_time < CACHE_TIMEOUT )); then
            grep "^${cache_key}=" "$CACHE_FILE" 2>/dev/null | cut -d'=' -f2
            return 0
        fi
    fi
    
    # Cache miss - fetch and store
    local status=$(wpctl get-volume "$target")
    mkdir -p "$(dirname "$CACHE_FILE")"
    
    if [[ $status == *"[MUTED]"* ]]; then
        echo "${cache_key}=muted" >> "$CACHE_FILE"
        echo "muted"
    else
        local vol=$(echo "$status" | awk '{print int($2 * 100)}')
        echo "${cache_key}=unmuted" >> "$CACHE_FILE"
        echo "${cache_key}_vol=${vol}" >> "$CACHE_FILE"
        echo "unmuted"
    fi
}

invalidate_cache() {
    rm -f "$CACHE_FILE"
}

case $1 in
    "speaker")
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
        invalidate_cache
        SINK_STATUS=$(get_cached_status @DEFAULT_AUDIO_SINK@)
        MIC_STATUS=$(get_cached_status @DEFAULT_AUDIO_SOURCE@)

        if [ "$SINK_STATUS" == "unmuted" ]; then
            if [ "$MIC_STATUS" == "muted" ]; then
                echo "1" > "$STATE_FILE"
            else
                echo "0" > "$STATE_FILE"
            fi
            
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
            wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
        else
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
            
            if [ -f "$STATE_FILE" ]; then
                LAST_STATE=$(cat "$STATE_FILE")
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ "$LAST_STATE"
            else
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
            fi
        fi
        ;;

    "toggle-mic")
        invalidate_cache
        SINK_STATUS=$(get_cached_status @DEFAULT_AUDIO_SINK@)

        if [ "$SINK_STATUS" == "muted" ]; then
            notify-send -u low "Sevastopol Audio" "Cannot enable Mic while System Audio is Muted."
        else
            wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        fi
        ;;
esac
