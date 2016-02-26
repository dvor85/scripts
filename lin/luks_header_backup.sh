#!/bin/bash

BD=/mnt/backup/luksHeaderBackup
mkdir -p $BD 
for d in /dev/disk/by-id/scsi*; do 
    cryptsetup luksHeaderBackup -v $d --header-backup-file $BD/${d#/dev/disk/by-id/}.header; 
done
