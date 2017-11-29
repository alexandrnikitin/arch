#!/bin/bash

parted /dev/sda -s "mklabel msdos"
parted /dev/sda -s "mkpart primary ext4 0% 100%"
parted /dev/sda -s "set 1 boot on"

mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt


timedatectl set-ntp true
pacstrap /mnt base
#Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

cp chroot_install.sh /mnt/root
arch-chroot /mnt /root/chroot_install.sh

umount -R /mnt
rm /mnt/root/chroot_install.sh

echo "Installation completed. Please reboot (systemctl reboot)"

