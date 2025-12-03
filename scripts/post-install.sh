#! /usr/bin/bash

DOTFILES="$HOME/dotfiles/config"

cd ~

echo "Linking configurations..."

configs=(hypr kitty nvim rofi waybar dunst git btop satty lazygit fastfetch systemd)

for config in "${configs[@]}"; do
    rm -rf "$HOME/.config/$config"
    ln -s "$DOTFILES/$config" "$HOME/.config/$config"
    echo "Linked $config"
done

echo "Installing Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

echo "Installing Zsh Plugins..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

rm -rf "$HOME/.zshrc"
ln -s "$HOME/dotfiles/config/.zshrc" "$HOME/.zshrc"

echo "Setting up custom scripts..."

chmod +x "$HOME/dotfiles/scripts/system/create-webapp.sh"
chmod +x "$HOME/dotfiles/scripts/system/delete-webapp.sh"

sudo ln -sf "$HOME/dotfiles/scripts/system/create-webapp.sh" /usr/local/bin/create-webapp
sudo ln -sf "$HOME/dotfiles/scripts/system/delete-webapp.sh" /usr/local/bin/delete-webapp

mkdir -p "$HOME/.local/share/applications"

cat <<EOF > "$HOME/.local/share/applications/delete-webapp.desktop"
[Desktop Entry]
Name=Delete Webapp
Comment=Remove an existing web app
Exec=/usr/local/bin/delete-webapp
Icon=user-trash
Terminal=false
Type=Application
Categories=Utility;Settings;
EOF

echo "Setting fzf..."
source <(fzf --zsh)

echo "Setting up printer..."
sudo systemctl enable --now cups

echo "Setting Losslesscut..."
sudo mkdir -p /usr/share/losslesscut/resources/
sudo ln -sf /usr/bin/ffmpeg /usr/share/losslesscut/resources/ffmpeg
sudo ln -sf /usr/bin/ffprobe /usr/share/losslesscut/resources/ffprobe

echo "Setting defualt web browser..."
xdg-settings set default-web-browser firefox.desktop
xdg-mime default firefox.desktop x-scheme-handler/http
xdg-mime default firefox.desktop x-scheme-handler/https
xdg-mime default firefox.desktop text/html

echo "Setting up rclone..."
rclone config
systemctl --user daemon-reload
systemctl --user enable rclone@google-drive
systemctl --user start rclone@google-drive

echo "Setup Complete! Please restart your shell or log out."

echo "HandleLidSwitch=suspend"

nvim /etc/systemd/logind.conf


