#! /usr/bin/bash


sudo pacman -S --noconfirm neovim git curl htop base-devel waybar rofi cliphist wl-clipboard ripgrep lazygit

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

pacman -S --noconfirm hypridle  hyprlock dunst libnotify fastfetch ttf-firacode-nerd ttf-jetbrains-mono-nerd pamixer cliphist slurp grim github-cli ntfs-3g noto-fonts-emoji

yay -S --noconfirm brave-bin dunst hyprpaper light swappy pulseaudio swaylock-effects-git hyprpicker-git 

sudo pacman -Syu --noconfirm
