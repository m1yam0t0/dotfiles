#!/usr/bin/env sh

# install require packages for yay
sudo pacman -S --noconfirm --needed \
    git \
    base-devel

# check destribution
dist_id=$(lsb_release -si)
echo "Distributor ID:${dist_id}"

# install yay
if [ "${dist_id}" = "Arch" ]; then
    echo "Manually Install yay"

    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    cd -
    rm -rf yay-bin
else
    echo "Install yay via pacman"
    sudo pacman -S --noconfirm --needed yay
fi

# install packages
yay -S --noconfirm --needed --cleanafter \
    1password \
    1password-cli \
    fcitx5-mozc-ut \
    light-git \
    mozc-ut \
    ttf-meslo-nerd-font-powerlevel10k \
    visual-studio-code-bin

# clean packages
yay -c --noconfirm
