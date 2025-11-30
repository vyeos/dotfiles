#!/usr/bin/env bash

# 1. Prompt for App Name
APP_NAME=$(rofi -dmenu -p "Webapp Name" -lines 0)
[ -z "$APP_NAME" ] && exit 0

# 2. Prompt for URL
URL=$(rofi -dmenu -p "URL" -lines 0)
[ -z "$URL" ] && exit 0

# Add https:// if missing
if [[ "$URL" != http* ]]; then
    URL="https://$URL"
fi

# 3. Sanitize name for filename
SAFE_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
FILE_PATH="$HOME/.local/share/applications/webapp-${SAFE_NAME}.desktop"

# 4. Create the .desktop file using BRAVE for App Mode
# Note: The '--app=' flag is what removes the address bar and tabs.

cat <<EOF > "$FILE_PATH"
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Comment=Webapp for $APP_NAME
# key change here:
Exec=brave --app="$URL"
Icon=web-browser
Terminal=false
Categories=Network;WebBrowser;
EOF

# 5. Notify
notify-send "Webapp Created" "$APP_NAME created!"
