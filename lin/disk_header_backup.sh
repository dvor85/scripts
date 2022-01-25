#!/bin/bash

usage() 
{
    echo "$(basename "$0") <backup dir>"
}

[[ -z "$1" ]] && usage && exit 1

BD="$1"
PASSED=""

mkdir -p $BD
for d in /dev/disk/by-id/*; do 
    disk="$(readlink -f $d)"
    if [[ -z $(echo -e "$PASSED" | sed -n "\#$disk#p") ]]; then
        curr_h=$BD/${d#/dev/disk/by-id/}.dump
        sfdisk --force --dump $d > "$curr_h" 
    fi
    PASSED="$PASSED\n$disk"
done
find $BD -size 0b -delete
