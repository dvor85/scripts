#!/bin/bash

usage() {
    echo "Usage $(basename $0) <certfile>"
}
[[ -z $1 ]] && usage && exit 1

certfile=$(realpath -e "$1")
certname=$(basename ${certfile%.*})
 
for certDB in $(find ~/ -name "cert9.db")
do
    certdir=$(dirname ${certDB});
    certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}
done
