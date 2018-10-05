NAME	:=	vps

# TODO
# default NEWVPS and HDSIZE and rename by passing in with make NEWVPS=xxxx
# when default vars are created can then modify same todo-make-targets appropriately
# 
# target for getting dhcp leases
# virsh net-dhcp-leases default
#
# target for cloning
# virt-clone --original bunty --auto-clone --name staked1
#
# target for virt-sysprep to clone  host from a "default" VM
# virt-sysprep -d staked1 --hostname staked1 --firstboot-command 'dpkg-reconfigure openssh-server'

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
