#!/bin/bash

ROOT_PASSWORD="password"

TIMEZONE="Europe/Vilnius"
LOCALE="en_US.UTF-8"
HOSTNAME="arch"
LANG="en_US.UTF-8"

ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

# Uncomment needed localisations
sed -i '/^#$LOCALE /s/^#//' /etc/locale.gen
locale-gen
echo LANG=$LANG > /etc/locale.conf

echo $HOSTNAME > /etc/hostname

pacman -S --noconfirm grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "root:$ROOT_PASSWORD" | chpasswd

pacman -S --noconfirm intel-ucode
grub-mkconfig -o /boot/grub/grub.cfg

fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab

systemctl enable dhcpcd.service
