#!/bin/bash

#lsmod | grep bridge
#brctl show
#reboot
HOSTIP=`ip a | grep "inet " | grep -v "127.0.0" | awk  '{print $2}' | sed 's/\/.*//'`
#HOSTNETMASK=`ifconfig eth0 | grep "inet addr" | cut -d ':' -f 4 | cut -d ' ' -f 1`
HOSTNETMASK="255.255.255.192"
NICHEX=$(hexdump -vn3 -e '/3 "52:54:00"' -e '/1 ":%02x"' -e '"\n"' /dev/urandom)
GUESTNET="172.16.240.1/29"
GUEST1="172.16.240.2"
GUEST2="172.16.240.3"
GUEST3="172.16.240.4"
GUEST4="172.16.240.5"
GUEST5="172.16.240.6"
GUEST6="172.16.240.7"
/bin/cp /etc/network/interfaces /etc/network/interfaces.bak
cat >> /etc/network/interfaces << EOF;

#KVM bridge stuff for custom routed network
# equivalent of 
# ip link add virbr10-dummy address $NICHEX  type dummy
auto virbr10-dummy
iface virbr10-dummy inet manual
  pre-up /sbin/ip link add virbr10-dummy type dummy                                                                                                                            
  up /sbin/ip link set virbr10-dummy address $NICHEX

auto virbr10                                                                                                                                                                   
iface virbr10 inet static                                                                                                                                                      
    # Make sure bridge-utils is installed!                                                                                                                                     
    bridge_ports virbr10-dummy                                                                                                                                                 
    bridge_stp on                                                                                                                                                              
    bridge_fd 2                                                                                                                                                                
    address $HOSTIP
    netmask $HOSTNETMASK
    up route add -host $GUEST1/32 dev virbr10                                                                                                                           
    up route add -host $GUEST2/32 dev virbr10                                                                                                                           
    up route add -host $GUEST3/32 dev virbr10                                                                                                                           
    up route add -host $GUEST4/32 dev virbr10                                                                                                                           
    up route add -host $GUEST5/32 dev virbr10                                                                                                                           
    up route add -host $GUEST6/32 dev virbr10                                                                                                                           
    #up route add -host 172.16.240.40/32 dev virbr10 
EOF

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
sysctl -p

/sbin/iptables-save > /etc/network/iptables_rules
echo "" >> /etc/iptables_rules
grep COMMIT /etc/network/iptables_rules | tail -1 | sed -i 's/COMMIT/#COMMIT/' /etc/network/iptables_rules
cat >> /etc/network/iptables_rules << EOF;

# Allow inbound traffic to the private subnet.
-A FORWARD -d $GUESTNET -o virbr10 -j ACCEPT
# Allow outbound traffic from the private subnet.
-A FORWARD -s $GUESTNET -i virbr10 -j ACCEPT
# Allow inbound traffic to the ip
#-A FORWARD -d 172.16.240.40/32 -o virbr10 -j ACCEPT
# Allow outbound traffic from the ip
#-A FORWARD -s 172.16.240.40/32 -i virbr10 -j ACCEPT
COMMIT
EOF

sed -i 's/exit 0//' /etc/rc.local
echo "/sbin/iptables-restore < /etc/network/iptables_rules" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
