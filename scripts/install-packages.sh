#! /usr/bin/bash

cd ~
sudo pacman -Syu --noconfirm hyprland kitty waybar \
    neovim git curl btop base-devel \
    cliphist wl-clipboard wl-clip-persist satty hypridle hyprlock \
    yad dunst fastfetch ttf-jetbrains-mono-nerd noto-fonts-emoji \
    pamixer slurp grim ntfs-3g wireplumber \
    bluez bluez-utils bluetui \
    impala iwd jq \
    upower rtkit ripgrep rust go zig cargo gum \
    pavucontrol thunar gvfs thunar-volman nwg-look \
    qt5-wayland qt6-wayland brightnessctl \
    nodejs npm imagemagick fzf \
    cups system-config-printer gutenprint \
    spotify-player wf-recorder ffmpeg libreoffice-fresh \
    xdg-desktop-portal-hyprland pipewirer\

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

yay -Syu --noconfirm hyprpaper hyprpicker-git github-cli brave-bin hyprpolkitagent localsend-bin losslesscut-bin

sudo pacman -Syu --noconfirm
yay -Syu --noconfirm
