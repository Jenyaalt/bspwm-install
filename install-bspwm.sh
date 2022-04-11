USERNAME="$(whoami)"


function welcome() {
    printf "\:: Install bwpwm ::\n"    
}


function install_reflector() {
    printf "\nInstalling reflector:\n"
    sudo pacman --noconfirm -S reflector
    
    printf "\nConfigure reflector\n"
    sudo reflector -c Belarus -c Poland -c Latvia -c Lithuania -c Russia -c Ukrain -a 12 -p https -p http --save /etc/pacman.d/mirrorlist

    printf "\nEnabling reflector:\n"
    sudo systemctl enable reflector.service
}


function update_and_upgrade() {
    sudo pacman -Syyuu
}


function install_xorg() {
    printf "\nInstalling xorg:\n"
    sudo pacman --noconfirm -S xorg
}


function install_video_drivers() {
    MACHINE="$(hostnamectl status)"
    if [[ $MACHINE == *"Virtualization:"* ]]
    then
        echo "Installing virtualbox drivers"
        sudo pacman --noconfirm -S virtualbox-guest-utils xf86-video-fbdev
    else
        echo "Installing nvidia drivers and utils"
        sudo pacman --noconfirm -S nvidia nvidia-utils
    fi
}


function install_xorg() {
    printf "\nInstalling xorg:\n"
    sudo pacman --noconfirm -S xorg
}


function install_yay_aur_helper() {
    printf "\nInstalling yay AUR helper:\n"
    cd %HOME
    git clone https://aur.archlinux.org/yay-git.git
    sudo chown -R ${USERNAME}:${USERNAME} ./yay-git
    cd yay-git
    makepkg -si
    cd ..
    rm -rf yay yay-git
}


function install_packages(){
    printf "\nInstalling packages:\n"

    while IFS= read -r CURRENT_LINE
        do
            if [[ $CURRENT_LINE != "" ]]
            then
                if [[ $CURRENT_LINE == *"yay"* ]]
                then                
                    PACKAGE=$(echo "$CURRENT_LINE" | sed 's/yay//')
                    # echo "yay --noconfirm -S $PACKAGE"
                    yay --noconfirm -S $PACKAGE
                else
                    # echo "sudo pacman --noconfirm -S $CURRENT_LINE"
                    sudo pacman --noconfirm -S $CURRENT_LINE
                fi
            fi
    done < packages.txt
}


welcome
install_reflector
update_and_upgrade
install_xorg
install_video_drivers
install_yay_aur_helper
install_packages

