#!/bin/bash


###########################################################
########## http://www.kriskinc.com/intel-pod ##############
# -0x0010: ff ff ff ff 6b 02 00 00 86 80 d3 10 ff ff 5a c0 
# +0x0010: 01 01 ff ff 6b 02 d3 10 d9 15 d3 10 ff ff 58 85 
#                
# -0x0030: c9 6c 50 31 3e 07 0b 46 84 2d 40 01 00 f0 06 07 
# +0x0030: c9 6c 50 21 3e 07 0b 46 84 2d 40 01 00 f0 06 07 
#                
# -0x0060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
# +0x0060: 20 01 00 40 16 13 ff ff ff ff ff ff ff ff ff ff

###########################################################


[[ -z $1 ]] && echo "Usage $0 <interface>" && exit

bdf=$(ethtool -i $1 | grep "bus-info:" | awk '{print $2}')
dev=$(lspci -s $bdf -x | grep "00: 86 80" | awk '{print "0x"$5$4$3$2}')

is_10=`ethtool -e $1 offset 0x10 length 16 | grep 'ff ff ff ff 6b 02 00 00 86 80 d3 10 ff ff 5a c0'`
is_30=`ethtool -e $1 offset 0x30 length 16 | grep 'c9 6c 50 31 3e 07 0b 46 84 2d 40 01 00 f0 06 07'`
is_60=`ethtool -e $1 offset 0x60 length 16 | grep 'ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff'`


if [[ -n $is_10 ]]; then
    echo "offset 10"    
elif [[ -n $is_30 ]]; then
    echo "offset 30"
    echo -n "fix it? ( Y|n ) "
    read an
    if [[ ( -z $an ) || ( $an = 'y' ) || ( $an = 'Y' ) ]]; then
	ethtool -E $1 magic $dev offset 0x33 value 0x21
    fi
elif [[ -n $is_60 ]]; then
    echo 'offset 60'
else
    echo "Nothing to do"
fi
