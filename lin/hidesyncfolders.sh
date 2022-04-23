#!/bin/bash

usage()
{
    echo "$(basename $0) <folder>"
}


[[ -z "$1" ]] && usage && exit 1

find "$1" -type d \( -name ".stfolder" -o -name ".stversions" \) -exec chmod 2700 {} \;
find "$1" -type d \( -name ".stfolder" -o -name ".stversions" \) -exec chown -R bak {} \;

find -L "$1" -type f -name "*.stignore" -exec chown -R bak {} \;
find -L "$1" -type f -name "*.stignore" -exec chmod 600 {} \;


