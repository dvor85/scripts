#!/bin/bash

#https://github.com/Fusl/opennic-resolvconf-update.git
#require fping,dig,curl

resolv_conf=/home/demon/opennic-resolvconf-update/resolvconf.sh
dns_opennic=/etc/NetworkManager/dnsmasq.d/opennic
servers=`cd $(dirname $resolv_conf) && $resolv_conf | awk '{print $2}'`
for s in $servers; do
    if [[ -n $(dig +timeout=1 +short @$s rutor.lib) ]]; then
	echo "Found dns server $s!"
	echo "server=/.lib/.coin/.emc/.bazar/$s" > $dns_opennic
	systemctl restart network-manager
	break
    fi
done;