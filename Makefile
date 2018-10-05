NAME	:=	vps

vps:
	echo ${NAME}
	echo ${NEWVPS}
ifndef NEWVPS
$(error NEWVPS is not set)
endif
ifndef HDSIZE
$(error HDSIZE is not set)
endif
	sleep 5
	virt-install --name ${NEWVPS} --ram 4096 --disk path=/var/lib/libvirt/images/${NEWVPS}.img,bus=virtio,size=${HDSIZE} --cdrom /home/pioneermylo/ubuntu-16.04.5-server-amd64.iso --network network=default,model=virtio --graphics vnc,listen=0.0.0.0,password=protectme --vcpus 4 --noautoconsole -v
