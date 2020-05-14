#!/bin/sh

if [ "$(whoami)" != "root" ]; then
        echo "Script muss als root ausgeführt werden!"
        exit 255
fi
sudo cp /etc/sudoers /etc/sudoers.bak
sudo echo 'nvidia ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
