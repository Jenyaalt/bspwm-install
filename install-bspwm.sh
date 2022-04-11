USERNAME="$(whoami)"


function welcome() {
    printf "=========================="    
    printf "\n\n:: Install bwpwm ::\n"    
    printf "=========================="    
}


function install_reflector() {
    printf "\n\nInstalling reflector:\n"
    sudo pacman --noconfirm -S reflector
    
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
    sudo pacman --noconfirm -S xorg
}


function install_video_drivers() {
    MACHINE="$(hostnamectl status)"
    if [[ $MACHINE == *"Virtualization:"* ]]
    then
        printf "\n\nInstalling virtualbox drivers"
        sudo pacman --noconfirm -S virtualbox-guest-utils xf86-video-fbdev
    else
        printf "\n\nInstalling nvidia drivers and utils"
        sudo pacman --noconfirm -S nvidia nvidia-utils
    fi
}


function install_xorg() {
    printf "\n\nInstalling xorg:\n"
    sudo pacman --noconfirm -S xorg
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
    printf "\n\nInstalling packages:\n"

    while IFS= read -r CURRENT_LINE
        do
            if [[ $CURRENT_LINE != "" ]]
            then
                if [[ $CURRENT_LINE == *"yay"* ]]
                then                
                    PACKAGE=$(printf "$CURRENT_LINE" | sed 's/yay//')
                    # printf "yay --noconfirm -S $PACKAGE"
                    yay --noconfirm -S $PACKAGE
                else
                    # printf "sudo pacman --noconfirm -S $CURRENT_LINE"
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
