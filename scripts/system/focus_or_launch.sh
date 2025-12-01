#!/usr/bin/env bash

# USAGE: ./tui_smart_move.sh <CLASS_NAME> <COMMAND>
# Example: ./tui_smart_move.sh sys_bt "kitty --class sys_bt -e bluetui"

CLASS="$1"
CMD="$2"

# 1. CHECK DEPENDENCIES
if ! command -v jq &> /dev/null; then
    notify-send "Error" "jq is missing. Install with: sudo pacman -S jq"
    exit 1
fi

# 2. FIND THE WINDOW
# We get the Window Address and its Workspace ID
WINDOW_DATA=$(hyprctl clients -j | jq -r --arg c "$CLASS" '.[] | select(.class == $c)')
WINDOW_ADDR=$(echo "$WINDOW_DATA" | jq -r ".address")
WINDOW_WS=$(echo "$WINDOW_DATA" | jq -r ".workspace.id")

# 3. GET CURRENT WORKSPACE
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r ".id")

# 4. LOGIC HANDLER
if [[ "$WINDOW_ADDR" != "null" && -n "$WINDOW_ADDR" ]]; then
    # --- CASE: Window Exists ---
    
    # Always close the existing instance first
    hyprctl dispatch closewindow "address:$WINDOW_ADDR"

    # LOGIC:
    # If it was on the SAME workspace, we just close it (Toggle off).
    # If it was on a DIFFERENT workspace, we close it AND launch a new one here.
    
    if [[ "$WINDOW_WS" == "$CURRENT_WS" ]]; then
        exit 0
    fi
    
    # Small safety delay to let Hyprland register the close
    sleep 0.1
fi

# 5. LAUNCH NEW INSTANCE
# We use 'setsid' (like Omarchy) to detach the process so it runs independently.
# We use 'sh -c' to ensure arguments in the command string are parsed correctly.
setsid /bin/sh -c "$CMD" &> /dev/null &
