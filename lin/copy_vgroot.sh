#!/bin/bash

mkdir -p /mnt/src && mkdir -p /mnt/dst

mkfs.ext4 /dev/vgroot/rootfs
if mount /dev/disk/by-uuid/29988eb0-8148-4cb1-ba63-8df02219ab83 /mnt/src && mount /dev/vgroot/rootfs /mnt/dst; then
    find /mnt/src -maxdepth 1 -mindepth 1 -exec cp -auxf {} /mnt/dst/ \;
    umount /mnt/src && umount /mnt/dst
fi;

mkfs.ext4 /dev/vgroot/usr
if mount /dev/disk/by-uuid/13756193-4bf3-465b-9388-bd0f33c0584a /mnt/src && mount /dev/vgroot/usr /mnt/dst; then
    find /mnt/src -maxdepth 1 -mindepth 1 -exec cp -auxf {} /mnt/dst/ \;
    umount /mnt/src && umount /mnt/dst
fi;

mkfs.ext4 /dev/vgroot/var
if mount /dev/disk/by-uuid/54958921-a489-4bf4-b885-ef4c7bf073d1 /mnt/src && mount /dev/vgroot/var /mnt/dst; then
    find /mnt/src -maxdepth 1 -mindepth 1 -exec cp -auxf {} /mnt/dst/ \;
    umount /mnt/src && umount /mnt/dst
fi;


echo SUCCSESS!!! NOW YOU MUST EDIT FSTAB, GRUB AND REBOOT!
