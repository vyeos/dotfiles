#!/usr/bin/env bash

# SEVASTOPOL OSD SERVER
# Usage: ./osd_server.sh [vol+|vol-|bri+|bri-|mute]

# Theme Colors
COLOR_ACCENT="#ffb86c" # Amber
# ICON_DIR="/usr/share/icons/Papirus-Dark/16x16"

# ---------------------------------------------------------

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

get_brightness() {
    brightnessctl i | grep -oP '\d+%' | head -n1 | tr -d '%'
}

send_notification() {
    TITLE=$1
    VALUE=$2
    ICON=$3
    ID=$4

    # dunstify arguments:
    # -r : Replace existing ID (prevents stack piling)
    # -h int:value:$VALUE : Shows the progress bar
    # <span> : Colors the number Amber
    dunstify -r "$ID" \
             -a "OSD" \
             -i "" \
             -h int:value:"$VALUE" \
             "$TITLE" \
             "Level: <span foreground='$COLOR_ACCENT' font_weight='bold'>${VALUE}%</span>"
}

case $1 in
    "vol+")
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
        VAL=$(get_volume)
        send_notification "Volume" "$VAL" "audio-volume-high" 1001
        ;;
    "vol-")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        VAL=$(get_volume)
        send_notification "Volume" "$VAL" "audio-volume-low" 1001
        ;;
    "mute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep "MUTED")
        if [ -n "$MUTED" ]; then
             dunstify -r 1001 -a "OSD" -i "" "Volume" "System <span foreground='#ff5555'>MUTED</span>"
        else
             VAL=$(get_volume)
             send_notification "Volume" "$VAL" "audio-volume-high" 1001
        fi
        ;;
    "bri+")
        brightnessctl s 5%+
        VAL=$(get_brightness)
        send_notification "Brightness" "$VAL" "display-brightness-high" 1002
        ;;
    "bri-")
        brightnessctl s 5%-
        VAL=$(get_brightness)
        send_notification "Brightness" "$VAL" "display-brightness-low" 1002
        ;;
esac
