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

sudo cpupower frequency-set -g schedutil

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

echo "Doing shit from claude..."
echo "sudo visudo -f /etc/sudoers.d/power-management"
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/cpupower
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/iw
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/bus/usb/devices/*/power/control
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/scsi_host/host*/link_power_management_policy
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /proc/sys/vm/dirty_writeback_centisecs

echo "nvim /etc/default/grub"
echo "in GRUB_CMDLINE_LINUX: pcie_aspm=force intel_pstate=passive"

echo "sudo systemctl enable tlp.service
sudo systemctl start tlp.service"


echo "Edit /etc/tlp.conf"
echo "
# CPU
CPU_SCALING_GOVERNOR_ON_AC=schedutil
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# WiFi
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on

# Runtime PM
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto
"

echo "
# Check what's running
systemctl --user list-units --type=service --state=running

# Example: Disable unused daemons
systemctl --user disable spotify-player.service 2>/dev/null
"

echo "
firefox - about: config
gfx.webrender.all = true
layers.acceleration.force-enabled = true
media.ffmpeg.vaapi.enabled = true
media.hardware-video-decoding.force-enabled = true
"

echo "sudo nvim /etc/default/cpupower
governor='schedutil'
sudo systemctl enable --now cpupower
"

