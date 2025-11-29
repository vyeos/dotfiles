#! /usr/bin/bash

cd ~
rm -rf /home/vyeos/.config/hypr
rm -rf /home/vyeos/.config/kitty
ln -s /home/vyeos/dotfiles/config/hypr /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/nvim /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/rofi /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/waybar /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/dunst /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/kitty /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/git /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/swappy /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/Thunar /home/vyeos/.config
ln -s /home/vyeos/dotfiles/config/btop /home/vyeos/.config

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions 
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

rm -rf /home/vyeos/.zshrc
ln -s /home/vyeos/dotfiles/config/.zshrc /home/vyeos/
