#!/bin/bash
echo "Folgende Ergänzung vornehmen:"
echo "APPEND ${cbootargs} rootfstype=ext4 root=/dev/mmcblk0p1 rw rootwait 3"
echo "um die GUI wieder zu aktivieren:"
echo "APPEND ${cbootargs} quiet"
read -p "weiter mit Enter"
nano /boot/extlinux/extlinux.conf


