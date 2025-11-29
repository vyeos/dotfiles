#!/usr/bin/env bash

# 1. Prompt for App Name
APP_NAME=$(rofi -dmenu -p "Webapp Name" -lines 0)
[ -z "$APP_NAME" ] && exit 0

# 2. Prompt for URL
URL=$(rofi -dmenu -p "URL (https://...)" -lines 0)
[ -z "$URL" ] && exit 0

# Add https:// if missing
if [[ "$URL" != http* ]]; then
    URL="https://$URL"
fi

# 3. Sanitize the name for the filename (lowercase, no spaces)
SAFE_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
FILE_PATH="$HOME/.local/share/applications/webapp-${SAFE_NAME}.desktop"

# 4. Create the .desktop file
# NOTE: If you prefer Brave (for no address bar), switch the Exec line below.

cat <<EOF > "$FILE_PATH"
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Comment=Webapp for $APP_NAME
# OPTION 1: Firefox (Standard window)
Exec=firefox --new-window "$URL" --class "webapp-$SAFE_NAME"
# OPTION 2: Brave (Frameless/App-like - Recommended for Webapps)
# Exec=brave --app="$URL" --user-data-dir="$HOME/.config/brave-webapps/$SAFE_NAME"
Icon=web-browser
Terminal=false
Categories=Network;WebBrowser;
StartupWMClass=webapp-$SAFE_NAME
EOF

# 5. Notify
notify-send "Webapp Created" "$APP_NAME is now in your launcher!"
