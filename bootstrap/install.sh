#!/bin/bash
set -e

timedatectl set-ntp true

parted /dev/sda -s "mklabel msdos"
parted /dev/sda -s "mkpart primary ext4 0% 100%"
parted /dev/sda -s "set 1 boot on"
mkfs.ext4 -O metadata_csum /dev/sda1

# parted /dev/sda -s mklabel gpt
# parted /dev/sda -s mkpart primary ext4 1MiB 512MiB
# parted /dev/sda -s set 1 esp on
# parted /dev/sda -s mkpart primary ext4 512MiB 100%
# parted /dev/sda -s align-check optimal 1
# mkfs.ext4 -O metadata_csum /dev/sda1
# mkfs.ext4 -O metadata_csum /dev/sda2

# TODO encrypt filesystem

mount /dev/sda1 /mnt

pacstrap /mnt base
# ==> WARNING: Possibly missing firmware for module: wd719x
# ==> WARNING: Possibly missing firmware for module: aic94xx
genfstab -U /mnt >> /mnt/etc/fstab
sed -r -e 's#rw,relatime#rw,noatime,data=ordered,commit=60,barrier=0#g' -i /mnt/etc/fstab

cp install_chroot.sh /mnt/root/
arch-chroot /mnt /root/install_chroot.sh
rm -f /mnt/root/install_chroot.sh

umount -R /mnt

echo ""
echo ""
echo "Installation completed, you can reboot safely now. (systemctl reboot)"
echo ""
echo ""
