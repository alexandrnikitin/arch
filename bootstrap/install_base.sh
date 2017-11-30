#!/bin/bash

timedatectl set-ntp true

parted /dev/sda -s "mklabel msdos"
parted /dev/sda -s "mkpart primary ext4 0% 100%"
parted /dev/sda -s "set 1 boot on"
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

cp chroot_install.sh /mnt/root
arch-chroot /mnt /root/chroot_install.sh

rm -f /mnt/root/chroot_install.sh
umount -R /mnt

echo "Installation completed. Please reboot (systemctl reboot)"
