#!/bin/bash
HOSTNAME=$1
IP=$2
GW=$3
cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
cat > /etc/netplan/50-cloud-init.yaml << EOF;
network:
    ethernets:
        ens3:
            addresses: []
            dhcp4: true
        ens7:
            addresses:
              - $IP/32
            routes:
              - to: 0.0.0.0/0
                via: $GW
                on-link: true
    version: 2
EOF
sed -i 's/^preserve_hostname\(.\)*$/preserve_hostname: true/' /etc/cloud/cloud.cfg
hostnamectl set-hostname $HOSTNAME
hostnamectl
