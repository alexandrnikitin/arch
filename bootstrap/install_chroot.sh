#!/bin/bash
set -e

ROOT_PASSWORD="password"
TIMEZONE="Europe/Vilnius"
LOCALE="en_US.UTF-8"
HOSTNAME="arch"
LANG="en_US.UTF-8"

ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

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
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.d/99-sysctl.conf

pacman -S --noconfirm base-devel python
pacman -S --noconfirm xorg-server xorg-xinit xorg-apps
pacman -S --noconfirm xf86-video-vesa xf86-input-mouse xf86-input-keyboard
pacman -S --noconfirm openssh virtualbox-guest-utils virtualbox-guest-modules-arch

systemctl enable dhcpcd.service
systemctl enable sshd.service
