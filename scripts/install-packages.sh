#! /usr/bin/bash


sudo pacman -Syu --noconfirm neovim git curl htop base-devel waybar rofi cliphist wl-clipboard ripgrep lazygit nodejs npm swappy

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

sudo pacman -S --noconfirm hypridle  hyprlock dunst libnotify fastfetch ttf-firacode-nerd ttf-jetbrains-mono-nerd pamixer cliphist slurp grim ntfs-3g noto-fonts-emoji wireplumber bluetui impala upower rtkit

yay -S --noconfirm brave-bin hyprpaper light sway pulseaudio swaylock-effects-git hyprpicker-git github-cli

sudo pacman -Syu --noconfirm
