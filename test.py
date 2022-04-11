#!/usr/bin/python
import os
import sys
import configparser
import time
import subprocess as sp


output_stream = os.popen('sudo pacman -Syyu')
output_stream.close()