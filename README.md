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
The default vps has an open vnc port for connecting to to install.  Quite insecure, so perhaps you may need to change it for your environment.  You can then tunnel the VNC through SSH with a command like
```
ssh -L5900:localhost:5900 user@xx.xx.xx.xx
```
VNC will be available at localhost:5900 and protected by the password `protectme`.  Best to change the password in the Makefile for your own security whilst limiting the hosts that can connect to localhost on the server.

## After installation of the first VM, remove VNC from definition
```
virsh dumpxml the_name > the_name.xml
```
Remove the graphics display line with the VNC definition.

## After installation, add a 2nd NIC for external IP address
Add an interface (network)
```
    <interface type='bridge'>
      <source bridge='virbr10'/>
      <target dev='vnet1'/>
      <model type='virtio' />
    </interface>
```
Depending on your bridge setup.  Custom routed bridge network is easiest for me to work with, and my bridge is at device `virbr10`.
