#!/bin/sh

if [ "$(whoami)" != "root" ]; then
        echo "Script muss als root ausgeführt werden!"
        exit 255
fi

sudo cp /etc/sudoers.bak /etc/sudoers

