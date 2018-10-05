# make-vps

Ubuntu 16.04 Host
```
apt-get update
apt-get upgrade
apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virtinst git virt-sysprep libguestfs-tools iptables ngrep 
```
Then
```
adduser `id -un` kvm
adduser `id -un` libvirtd
```
Clone this repo
```
git clone $THISREPO
cd make-vps
```
For the moment it defaults to using 4 CPUs and 4GB RAM, just edit the `Makefile` or copy the make target.
```
make vps NEWVPS=the_name HDSIZE=25
```
