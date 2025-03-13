#!/bin/bash

resolv_conf=/home/demon/opennic-resolvconf-update/resolvconf.sh
dns_opennic=/etc/NetworkManager/dnsmasq.d/opennic
if [[ -n $1 ]]; then
    servers=$1
else
    servers=`cd $(dirname $resolv_conf) && $resolv_conf | awk '{print $2}'`
fi
for s in $servers; do
    if dig +timeout=1 @$s rutor.lib | grep 'Query time'; then
	echo "Found dns server $s!"
	echo "server=/.lib/.coin/.emc/.bazar/$s" > $dns_opennic
	systemctl restart NetworkManager
	break
    fi
done;