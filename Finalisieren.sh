#!/bin/sh

if [ "$(whoami)" != "root" ]; then
        echo "Script muss als root ausgeführt werden!"
        exit 255
fi
sudo apt -y autoremove
sudo apt -y clean
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

