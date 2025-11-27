#! /usr/bin/bash

sudo pacman -Syu --noconfirm neovim git curl btop base-devel waybar rofi cliphist wl-clipboard lazygit nodejs npm swappy hypridle hyprlock dunst fastfetch ttf-jetbrains-mono-nerd pamixer cliphist slurp grim ntfs-3g noto-fonts-emoji wireplumber bluetui impala upower rtkit ripgrep rust go zig cargo gum

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

yay -S --noconfirm hyprpaper light sway hyprpicker-git github-cli walker elephant

sudo pacman -Syu --noconfirm
yay -Syu --noconfirm
