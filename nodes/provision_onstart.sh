#!/bin/bash

X=$1

echo "$X"

route add default gw 192.168."$X".1

eval "$(route -n | awk '{ if ($8 =="eth0" && $2 != "0.0.0.0") print "route del default gw " $2; }')"

chattr -i /etc/resolv.conf
echo -e "search corp$X.un\nnameserver 192.168.$X.10" > /etc/resolv.conf
chattr +i /etc/resolv.conf

echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/20-my-forward.conf && sysctl -p --system