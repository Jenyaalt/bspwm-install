echo "Starting install process:"
echo "=========================="

USERNAME = whoami


function welcome() {
    printf "\:: Install bwpwm ::\n"    
}


function init() {
    printf "\nInstalling reflector:\n"
    sudo pacman -S reflector
    
    printf "\nConfigure reflector\n"
    sudo reflector -c Belarus -c Poland -c Latvia -c Lithuania -c Russia -c Ukrain -a 12 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist

    printf "\nEnabling reflector:\n"
    sudo systemctl enable reflector.service
}


function install_xorg() {
    printf "\nInstalling xorg:\n"
    sudo pacman -S xorg
}


function install_video_drivers() {
    hostnamectl status
}


function install_xorg() {
    printf "\nInstalling xorg:\n"
    sudo pacman --noconfirm -S xorg
}


function install_packages(){
    printf "\nInstalling packages:\n"

    while IFS= read -r CURRENT_LINE
        do
            echo "$CURRENT_LINE"
    done < packages.ini    
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


function update_and_upgrade() {
    sudo pacman -Syyuu
}



welcome
update_and_upgrade
# init
install_yay_aur_helper
install_packages
