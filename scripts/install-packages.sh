#! /usr/bin/bash

cd ~
sudo pacman -Syu --noconfirm hyprland kitty waybar \
    neovim git curl btop base-devel \
    cliphist wl-clipboard wl-clip-persist satty hypridle hyprlock \
    yad dunst fastfetch ttf-jetbrains-mono-nerd noto-fonts-emoji \
    pamixer slurp grim ntfs-3g wireplumber \
    bluez bluez-utils bluetui \
    impala iwd jq yazi\
    upower rtkit ripgrep rust go zig cargo gum \
    pavucontrol nwg-look \
    tumbler ffmpegthumbnailer poppler-glib\
    qt5-wayland qt6-wayland brightnessctl \
    nodejs npm imagemagick fzf \
    cups system-config-printer gutenprint \
    spotify-player wf-recorder ffmpeg libreoffice-fresh \
    xdg-desktop-portal-hyprland pipewire\
    imv mpv bat file \
    rclone fuse3\

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

yay -Syu --noconfirm hyprpaper hyprpicker-git github-cli hyprpolkitagent localsend-bin losslesscut-bin

sudo pacman -Syu --noconfirm
yay -Syu --noconfirm
