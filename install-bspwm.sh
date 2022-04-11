#!/bin/bash


USERNAME="$(whoami)"


func_install() {
	if pacman -Qi $1 &> /dev/null; then
		tput setaf 2
  		echo "###############################################################################"
  		echo "################## The package "$1" is already installed"
      	echo "###############################################################################"
      	echo
		tput sgr0
	else
    	tput setaf 3
    	echo "###############################################################################"
    	echo "##################  Installing package "  $1
    	echo "###############################################################################"
    	echo
    	tput sgr0
    	$1 
    fi
}


function welcome() {
    printf "\n\n==========================\n"    
    printf ":: Install bwpwm ::\n"    
    printf "=========================="    
}


function install_reflector() {
    printf "\n\nInstalling reflector:\n"
    sudo pacman -S reflector
    
    printf "\n\nConfigure reflector\n"
    sudo reflector -c Belarus -c Poland -c Latvia -c Lithuania -c Russia -c Ukrain -a 12 -p https -p http --save /etc/pacman.d/mirrorlist

    printf "\n\nEnabling reflector:\n"
    sudo systemctl enable reflector.service
}


function update_and_upgrade() {
    sudo pacman -Syyuu
}


function install_xorg() {
    printf "\n\nInstalling xorg:\n"
    sudo pacman -S xorg
}


function install_video_drivers() {
    MACHINE="$(hostnamectl status)"
    if [[ $MACHINE == *"Virtualization:"* ]]
    then
        printf "\n\nInstalling virtualbox drivers"
        sudo pacman -S virtualbox-guest-utils xf86-video-fbdev
    else
        printf "\n\nInstalling nvidia drivers and utils"
        sudo pacman -S nvidia nvidia-utils
    fi
}


function install_xorg() {
    printf "\n\nInstalling xorg:\n"
    sudo pacman -S xorg
}


function install_yay_aur_helper() {
    printf "\n\nInstalling yay AUR helper:\n"
    cd %HOME
    git clone https://aur.archlinux.org/yay-git.git
    sudo chown -R ${USERNAME}:${USERNAME} ./yay-git
    cd yay-git
    makepkg -si
    cd ..
    rm -rf yay yay-git
}


function install_packages(){
    while IFS= read -r CURRENT_LINE
        do
            if [[ "$CURRENT_LINE" == *"#"* ]]
            then 
                :
            else
                if [[ $CURRENT_LINE == *"*"* ]]
                then                
                    INSTALL_SCRIPT=$(printf "yay -S --noconfirm --needed $CURRENT_LINE " | sed 's/* //')
                else
                    INSTALL_SCRIPT=$(printf "sudo pacman -S --noconfirm --needed $CURRENT_LINE ")
                fi
            fi

        func_install $INSTALL_SCRIPT
        # echo $INSTALL_SCRIPT

    done < packages.txt
}


welcome
install_reflector
update_and_upgrade
install_xorg
install_video_drivers
install_yay_aur_helper
install_packages
