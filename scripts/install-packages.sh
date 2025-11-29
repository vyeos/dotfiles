#! /usr/bin/bash

cd ~

sudo pacman -Syu --noconfirm neovim git curl btop base-devel waybar cliphist wl-clipboard lazygit nodejs npm swappy hypridle hyprlock dunst fastfetch ttf-jetbrains-mono-nerd pamixer slurp grim ntfs-3g noto-fonts-emoji wireplumber bluetui impala upower rtkit ripgrep rust go zig cargo gum pavucontrol thunar nwg-look

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

yay -Syu --noconfirm hyprpaper light hyprpicker-git github-cli brave-bin

sudo pacman -Syu --noconfirm
yay -Syu --noconfirm
