#!/usr/bin/python
import os
import sys
import configparser
import time
import subprocess as sp


cp = configparser.ConfigParser(allow_no_value=True)
cp.read('packages.ini')
username = sp.getoutput('whoami')




def install_packages():
    # cprint('\r\n:: Installing Regular packages...', fg='y', style='b')
    regPkgs = ''

    for pkg in cp['Regular']:
        regPkgs = regPkgs + pkg + ' '

    # os.system(f'sudo pacman --noconfirm -S {regPkgs}')
    print(f'sudo pacman --noconfirm -S {regPkgs}')
    # pause()



install_packages()