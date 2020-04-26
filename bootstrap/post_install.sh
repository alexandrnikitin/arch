#!/bin/bash
set -e

timedatectl set-ntp true

pacman -S --noconfirm reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector --latest 100 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacman -S --noconfirm virtualbox-guest-utils virtualbox-guest-modules-arch
sudo systemctl enable vboxservice
sudo systemctl start vboxservice
sudo VBoxClient-all
# TODO check autostart

ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -C "your_name@host"

pacman -S --noconfirm base-devel
pacman -S --noconfirm git
pacman -S --noconfirm python
pacman -S --noconfirm linux-headers
pacman -S --noconfirm chromium

echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

pacman -S --noconfirm tmux 
pacman -S --noconfirm stow 
pacman -S --noconfirm openssh
nnn ranger

pacman -S --noconfirm xorg xorg-xinit
pacman -S --noconfirm mesa xf86-video-vesa xf86-input-mouse xf86-input-keyboard



pacman -S --noconfirm pulseaudio pulseaudio-alsa
package_install "alsa-utils alsa-plugins"
