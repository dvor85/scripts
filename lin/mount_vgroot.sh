#!/bin/bash


case "$1" in

"start")
mount /dev/vgroot/rootfs /mnt/rootfs
umount /boot
mount /dev/disk/by-uuid/400bbc27-0674-4b21-9d9e-8e5d8b8a3fdf /mnt/rootfs/boot
mount /dev/vgroot/usr /mnt/rootfs/usr
mount /dev/vgroot/root /mnt/rootfs/root
mount /dev/vgroot/home /mnt/rootfs/home
mount /dev/vgroot/var /mnt/rootfs/var
mount -o bind /proc /mnt/rootfs/proc
mount -o bind /dev /mnt/rootfs/dev
mount -o bind /sys /mnt/rootfs/sys
;;
"stop")
umount /mnt/rootfs/sys
umount /mnt/rootfs/dev
umount /mnt/rootfs/proc
umount /mnt/rootfs/var
umount /mnt/rootfs/home
umount /mnt/rootfs/root
umount /mnt/rootfs/usr
umount /mnt/rootfs/boot
mount /boot
umount /mnt/rootfs
;;
*)
echo "Usage: $(basename $0) <start>|<stop>"
esac;

