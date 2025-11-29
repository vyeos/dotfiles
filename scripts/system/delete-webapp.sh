#!/usr/bin/env bash

APP_DIR="$HOME/.local/share/applications"

# 1. Get a list of webapps
# We assume files are named 'webapp-[name].desktop'
# We strip 'webapp-' and '.desktop' to show a clean list to the user
cd "$APP_DIR" || exit
APPS=$(ls webapp-*.desktop 2>/dev/null | sed -e 's/^webapp-//' -e 's/\.desktop$//')

# Check if list is empty
if [ -z "$APPS" ]; then
    notify-send "Webapp Manager" "No webapps found to delete."
    exit 0
fi

# 2. Show Rofi Menu
SELECTED=$(echo "$APPS" | rofi -dmenu -p "Delete Webapp" -lines 10)

# Exit if user pressed Esc
if [ -z "$SELECTED" ]; then
    exit 0
fi

# 3. Reconstruct filename and delete
TARGET_FILE="$APP_DIR/webapp-${SELECTED}.desktop"

if [ -f "$TARGET_FILE" ]; then
    rm "$TARGET_FILE"
    notify-send "Webapp Manager" "Deleted: $SELECTED"
else
    notify-send "Error" "Could not find file for $SELECTED"
fi
