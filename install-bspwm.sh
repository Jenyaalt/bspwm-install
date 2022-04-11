#!/bin/bash


USERNAME="$(whoami)"


function func_install() {
    if pacman -Qi $1 &> /dev/null
	then
		tput setaf 2
  		echo "###############################################################################"
  		echo ":: The package "$1" is already installed"
        echo "###############################################################################"
		tput sgr0    
	else
        tput setaf 3
        echo "###############################################################################"
        echo ":: Installing package "  $1 
        echo "###############################################################################"
        tput sgr0
        $2
	fi
}


function welcome() {
    echo "==================="    
    echo ":: Install bwpwm ::"    
    echo "==================="    
    echo
}


function update_and_upgrade() {
    sudo pacman -Syyuu
}

function install_video_drivers() {
    MACHINE="$(hostnamectl status)"
    if [[ $MACHINE == *"Virtualization:"* ]]
    then
        echo "Installing virtualbox drivers"
        func_install "virtualbox-guest-utils" "sudo pacman -S virtualbox-guest-utils"
        func_install "xf86-video-fbdev" "sudo pacman -S xf86-video-fbdev"
    else
        echo "Installing nvidia drivers and utils"
        func_install "nvidia" "sudo pacman -S nvidia"
        func_install "nvidia-utils" "sudo pacman -S nvidia-utils"        
    fi
}


function install_yay_aur_helper() {
    if ! [[ pacman -Qi yay-git &> /dev/null ]]
    then 
        echo "Installing yay AUR helper:"
        cd %HOME
        git clone https://aur.archlinux.org/yay-git.git
        sudo chown -R ${USERNAME}:${USERNAME} ./yay-git
        cd yay-git
        makepkg -si
        cd ..
        rm -rf yay yay-git
    fi
}


function install_packages(){
    while IFS= read -r PACKAGE
        do
            if ! [[ "$PACKAGE" == *"#"* ]]
            then 
                INSTALL_SCRIPT=$(echo "sudo pacman -S --noconfirm --needed $PACKAGE ")            
                func_install "$PACKAGE" "$INSTALL_SCRIPT"
            fi
    done < regular_packages.txt

    while IFS= read -r PACKAGE
        do
            if ! [[ "$PACKAGE" == *"#"* ]]
            then 
                INSTALL_SCRIPT=$(echo "yay -S --noconfirm --needed $PACKAGE ")
                func_install "$PACKAGE" "$INSTALL_SCRIPT"        
            fi
    done < aur_packages.txt    
}


function post_install_config() {
    echo "Enabling NetworkManager:"
    sudo systemctl enable NetworkManager.service

    echo "Enabling bluetooth:"
    sudo systemctl enable bluetooth.service     
}


function pre_install_config() {    
    echo "Configure reflector"
    sudo reflector -c Belarus -c Poland -c Latvia -c Lithuania -c Russia -c Ukrain -a 12 -p https -p http --save /etc/pacman.d/mirrorlist

    echo "Enabling reflector:"
    sudo systemctl enable reflector.service        
}


function reboot() {
    echo "====================================================="    
    echo ":: Successfully installed! ::"    
    echo "====================================================="    
    read -p 'Press any key to reboot'
    reboot
}


welcome
pre_install_config
update_and_upgrade
install_video_drivers
install_yay_aur_helper
install_packages
post_install_config
reboot
