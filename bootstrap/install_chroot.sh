#!/bin/bash
set -e

ROOT_PASSWORD="password"
USER_NAME="anikitin"
USER_PASSWORD="password"
HOSTNAME="arch"
TIMEZONE="US/Pacific"
LOCALE="en_US.UTF-8"
LANG="en_US.UTF-8"

ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc

sed -i "/^#$LOCALE /s/^#//" /etc/locale.gen
locale-gen
echo LANG=$LANG > /etc/locale.conf

echo $HOSTNAME > /etc/hostname

cat >>/etc/hosts <<EOL
127.0.0.1    localhost
::1    localhost
EOL

pacman -S --noconfirm grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S --noconfirm intel-ucode
grub-mkconfig -o /boot/grub/grub.cfg

fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.d/99-sysctl.conf

pacman -S --noconfirm sudo openssh

systemctl enable dhcpcd.service
systemctl enable sshd.service

echo "root:$ROOT_PASSWORD" | chpasswd

useradd -m --groups users,wheel $USER_NAME
echo "$USER_NAME:$USER_PASSWORD" | chpasswd
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
