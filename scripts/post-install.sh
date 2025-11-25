#! /usr/bin/bash

cd ~
git clone https://github.com/vyeos/dotfiles
ln -s /home/vyeos/dotfiles/.config/hypr /home/vyeos/.config/hypr
ln -s /home/vyeos/dotfiles/.config/nvim /home/vyeos/.config/nvim
ln -s /home/vyeos/dotfiles/.config/rofi /home/vyeos/.config/rofi
ln -s /home/vyeos/dotfiles/.config/waybar /home/vyeos/.config/waybar

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
rm -rf /home/vyeos/.zshrc
ln -s /home/vyeos/dotfiles/.config/.zshrc /home/vyeos/.zshrc
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions 
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
