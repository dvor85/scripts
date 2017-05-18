#!/bin/bash

if [[ -z $1 ]]; then
    echo "Usage $(basename $0) <mashinename>";
    exit 0;
else
    MACHINENAME=$1
fi

[[ -f /etc/default/virtualbox ]] && . /etc/default/virtualbox

if [[ -z $VBOXWEB_USER ]]; then
    VBOXWEB_USER=vbox
    usermod -G vboxusers -a $VBOXWEB_USER
    echo "VBOXWEB_USER=$VBOXWEB_USER" >> /etc/default/virtualbox
fi

if [[ -z $VBOXAUTOSTART_DB ]]; then
    VBOXAUTOSTART_DB=/etc/vbox
    echo "VBOXAUTOSTART_DB=$VBOXAUTOSTART_DB" >> /etc/default/virtualbox
fi
if [[ -z $VBOXAUTOSTART_CONFIG ]]; then
    VBOXAUTOSTART_CONFIG=/etc/vbox/autostart.cfg
    echo "VBOXAUTOSTART_CONFIG=$VBOXAUTOSTART_CONFIG" >> /etc/default/virtualbox
fi

mkdir -p `dirname  $VBOXAUTOSTART_CONFIG`
chmod 1770 `dirname $VBOXAUTOSTART_CONFIG`
chgrp vboxusers `dirname $VBOXAUTOSTART_CONFIG`

if [[ ! -f $VBOXAUTOSTART_CONFIG ]]; then
    echo "default_policy=allow" > $VBOXAUTOSTART_CONFIG
fi

sudo -u $VBOXWEB_USER VBoxManage setproperty autostartdbpath $VBOXAUTOSTART_DB
sudo -u $VBOXWEB_USER VBoxManage modifyvm $MACHINENAME --autostart-enabled on
sudo -u $VBOXWEB_USER VBoxManage modifyvm $MACHINENAME --autostop-type savestate

sudo -u $VBOXWEB_USER touch $VBOXAUTOSTART_DB/$VBOXWEB_USER.start
sudo -u $VBOXWEB_USER touch $VBOXAUTOSTART_DB/$VBOXWEB_USER.stop

chmod 600 $VBOXAUTOSTART_DB/$VBOXWEB_USER.*
