echo "Starting install process:"
echo "=========================="

me="$(whoami)"
echo "$me"

function welcome() {
    printf "\:: Install bwpwm ::\n"    
}


function init() {
    printf "\nInstalling reflector:\n"
    sudo pacman --noconfirm -S reflector
    
    printf "\nConfigure reflector\n"
    sudo reflector -c Belarus -c Poland -c Latvia -c Lithuania -c Russia -c Ukrain -a 12 -p https -p http --save /etc/pacman.d/mirrorlist

    printf "\nEnabling reflector:\n"
    sudo systemctl enable reflector.service
}


function install_xorg() {
    printf "\nInstalling xorg:\n"
    sudo pacman --noconfirm -S xorg
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


function install_yay_aur_helper() {
    printf "\nInstalling yay AUR helper:\n"
    cd %HOME
    git clone https://aur.archlinux.org/yay-git.git
    sudo chown -R ${me}:${me} ./yay-git
    cd yay-git
    makepkg -si
    cd ..
    rm -rf yay yay-git
}


function update_and_upgrade() {
    sudo pacman -Syyuu
}



welcome
init
update_and_upgrade
install_yay_aur_helper
install_packages
